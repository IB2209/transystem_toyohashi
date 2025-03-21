class MovementRecordsController < ApplicationController
  before_action :set_movement_record, only: [:edit, :update, :show, :destroy, :report, :print, :toggle_status_1, :toggle_status_2]
  before_action :set_schedule, only: [:new]

  # 一覧表示
  def index
     # 最新の日付が上にくるようにソート
  @movement_records = MovementRecord.all.order(move_date: :desc, departure_hour: :desc, departure_minute: :desc, id: :asc)

  # ✅ 月ごとにグループ化
  @grouped_movement_records = @movement_records.group_by { |record| record.move_date.beginning_of_month }

  # ✅ 日ごとにグループ化
  @grouped_movement_records.each do |month, records|
    @grouped_movement_records[month] = records.group_by(&:move_date)
  end

  # ✅ 各日付ごとに No. を降順で振る
  @record_numbers_by_date = {}
  @movement_records.group_by(&:move_date).each do |date, records|
    total_count = records.size
    @record_numbers_by_date[date] = {}
    records.each.with_index(0) do |record, index|
      @record_numbers_by_date[date][record.id] = total_count - index
    end
end

    # 総距離を計算
    @total_distance = @movement_records.sum do |record|
      if record.departure_distance.present? && record.arrival_distance.present?
        record.arrival_distance - record.departure_distance
      else
        0
      end
    end

    # 入庫表・出庫表への自動連携
    

    # 代金系の合計額を計算
    @total_toll_fee = @movement_records.sum { |record| record.toll_fee.to_i }
    @total_fuel_fee = @movement_records.sum { |record| record.fuel_fee.to_i }
    @total_transportation_fee = @movement_records.sum { |record| record.transportation_fee.to_i }
    @total_lodging_fee = @movement_records.sum { |record| record.lodging_fee.to_i }

    # すべての合計
    @total_cost = @total_toll_fee + @total_fuel_fee + @total_transportation_fee + @total_lodging_fee
  end

  # 新規作成フォーム
  def new
    @movement_record = MovementRecord.new(has_abnormality: false)
    if @schedule.present?
      @movement_record.schedule_id = @schedule.id
      @movement_record.responsible_person = @schedule.responsible_person
      @movement_record.model = @schedule.model
      @movement_record.chassis_number = @schedule.chassis_number
      @movement_record.pickup_location = @schedule.pickup_location
      @movement_record.delivery_location = @schedule.delivery_location
      
      
    end

    now = Time.current
  rounded_minute = (now.min / 15) * 15  # 15分単位に丸める

  @movement_record = MovementRecord.new(
    has_abnormality: false,               # 異常なしをデフォルト
    request_type: "いすゞ",                # 依頼のデフォルト
    vehicle_condition: "新車"              # 新中古のデフォルト
  )

  if @schedule.present?
    @movement_record.schedule_id = @schedule.id
    @movement_record.responsible_person = @schedule.responsible_person
    @movement_record.model = @schedule.model
    @movement_record.chassis_number = @schedule.chassis_number
    @movement_record.pickup_location = @schedule.pickup_location
    @movement_record.delivery_location = @schedule.delivery_location
    @movement_record.arrival_time = @schedule.arrival_time
    @movement_record.departure_time = @schedule.departure_time
  end
  end

  # 登録処理
  def create
    @movement_record = MovementRecord.new(movement_record_params)

    if @movement_record.save
      handle_in_out_entry(@movement_record)
      @movement_record.schedule.update(is_completed: true) if @movement_record.schedule.present?
      redirect_to movement_records_path, notice: '自走記録が登録されました。'
    else
      flash.now[:alert] = @movement_record.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  # 編集フォーム
  def edit
    @movement_record.departure_hour = @movement_record.departure_time&.hour if @movement_record.departure_hour.nil?
    @movement_record.departure_minute = @movement_record.departure_time&.min if @movement_record.departure_minute.nil?
    @movement_record.arrival_hour = @movement_record.arrival_time&.hour if @movement_record.arrival_hour.nil?
    @movement_record.arrival_minute = @movement_record.arrival_time&.min if @movement_record.arrival_minute.nil?
    @movement_record.request_type ||= "いすゞ"
    @movement_record.vehicle_condition ||= "新"
  end
  
  
  

  # 更新処理
  def update
    Rails.logger.debug "🔥 更新開始: movement_record_id=#{@movement_record.id}"
    Rails.logger.debug "🔥 更新内容: #{movement_record_params.inspect}"
  
    if @movement_record.update(movement_record_params)
      Rails.logger.debug "✅ 更新成功: #{@movement_record.inspect}"
      handle_in_out_entry(@movement_record)
      redirect_to movement_records_path, notice: '移動記録が更新されました。'
    else
      Rails.logger.debug "❌ 更新失敗: #{@movement_record.errors.full_messages}"
      flash.now[:alert] = @movement_record.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_entity
    end
  end
  

  # 詳細表示
  def show
  end

  # 削除処理
def destroy
  ActiveRecord::Base.transaction do
    # 🚀 先に `in_entries` / `out_entries` を削除
    InEntry.where(movement_record_id: @movement_record.id).destroy_all
    OutEntry.where(movement_record_id: @movement_record.id).destroy_all

    # 🚀 `movement_record` を削除
    @movement_record.destroy!
  end

  redirect_to movement_records_path, notice: '移動記録が削除されました。'
rescue StandardError => e
  Rails.logger.error "移動記録削除エラー: #{e.message}"
  flash[:alert] = "移動記録の削除に失敗しました。"
  redirect_to movement_records_path
end


# ステータス1のトグル
def toggle_status_1
  @movement_record = MovementRecord.find(params[:id]) # 修正: 変数名統一
  @movement_record.update(status_1: !@movement_record.status_1)

  respond_to do |format|
    format.json { render json: { new_status: @movement_record.status_1 } }
    format.html { redirect_to movement_records_path } # ページリロード回避のため通常はJSONを返す
  end
end

# ステータス2のトグル
def toggle_status_2
  @movement_record = MovementRecord.find(params[:id]) # 修正: 変数名統一
  @movement_record.update(status_2: !@movement_record.status_2)

  respond_to do |format|
    format.json { render json: { new_status: @movement_record.status_2 } } # JSONレスポンスを返す
    format.html { redirect_to movement_records_path }
  end
end

  

  # 日報ページ表示
  def report
    # 特定の移動記録を取得して表示
  end

  # 印刷処理
  def print
    # JavaScript を実行して印刷
    respond_to do |format|
      format.html { render :report }
      format.pdf do
        pdf = render_to_string pdf: "日報", template: "movement_records/report", layout: 'pdf'
        send_data pdf, filename: "日報_#{@movement_record.id}.pdf", type: "application/pdf"
      enddef exists_in_unshipped_list?
      # `InEntry` に存在し、`OutEntry` に存在しない `chassis_number` を「未出庫」と判定
      in_entry_exists = InEntry.where(chassis_number: chassis_number).exists?
      out_entry_exists = OutEntry.where(chassis_number: chassis_number).exists?
    
      # `InEntry` に存在し、`OutEntry` に存在しない場合のみ未出庫
      in_entry_exists && !out_entry_exists
    end
    
    end
  end

  private

  def set_movement_record
    @movement_record = MovementRecord.find(params[:id])
  end

  def set_schedule
    @schedule = Schedule.find_by(id: params[:schedule_id])
  end

  # Strong Parameters
  def movement_record_params
    params.require(:movement_record).permit(
      :schedule_id, :move_date, :responsible_person, :model,
      :chassis_number, :pickup_location, :waypoint, :delivery_location,
      :departure_hour, :departure_minute, :arrival_hour, :arrival_minute,
      :departure_distance, :arrival_distance, :fuel_fee_type, :fuel_fee, :fuel_amount,
      :toll_fee_type, :toll_fee, :transportation_fee_type, :transportation_fee,
      :lodging_fee_type, :lodging_fee, :has_abnormality, :message,
      :vehicle_condition, :request_type,
      :fuel_fee_detail, :toll_fee_detail, :transportation_fee_detail, :lodging_fee_detail
    )
  end
  
  
  
  
  # 入出庫表の連携処理
  def handle_in_out_entry(movement_record)
    if movement_record.delivery_location == "豊橋プール"
      create_new_in_entry(movement_record)
    end
  
    if movement_record.pickup_location == "豊橋プール"
      create_new_out_entry(movement_record)
    end
  end
  
  def create_new_in_entry(movement_record)
    return if InEntry.exists?(chassis_number: movement_record.chassis_number, entry_date: movement_record.move_date)

    in_entry = InEntry.create!(
      entry_date: movement_record.move_date || Date.today,
      driver_name: movement_record.responsible_person,
      model: movement_record.model,
      chassis_number: movement_record.chassis_number,
      pickup_location: movement_record.pickup_location,
      has_abnormality: movement_record.has_abnormality,
      message: movement_record.message,
      company_name: "コックス豊橋",
      movement_record_id: movement_record.id
    )
  
    Rails.logger.info "✅ InEntry 作成: #{in_entry.inspect}"
  end


  def create_new_out_entry(movement_record)
    # すでに関連する `OutEntry` がある場合、新しい `InEntry` に紐付けない
    existing_out_entry = OutEntry.find_by(chassis_number: movement_record.chassis_number, movement_record_id: movement_record.id)
    return if existing_out_entry.present? # すでに出庫データがあるなら何もしない
  
    # 🚀 `entry_date` を考慮して、正しく `InEntry` を紐づける
    in_entry = InEntry.where(chassis_number: movement_record.chassis_number)
                      .where("entry_date <= ?", movement_record.move_date) # **出庫日より前の入庫データのみ取得**
                      .where.not(id: OutEntry.select(:in_entry_id)) # **すでに出庫データがある `InEntry` は除外**
                      .order(entry_date: :desc, id: :desc)
                      .first
  
    return if in_entry.nil? # **該当する入庫データがない場合はスキップ**
end  
end
