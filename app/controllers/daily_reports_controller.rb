class DailyReportsController < ApplicationController
  before_action :set_daily_report, only: [:show, :edit, :update, :destroy]

  def index
    @daily_reports = DailyReport.includes(:movement_records).order(move_date: :desc)

    # 月ごとにデータをグループ化
    @daily_reports_by_month = @daily_reports.group_by { |report| report.move_date.beginning_of_month }

    # 担当者ごとにグループ化
    @daily_reports_by_month.transform_values! { |reports| reports.group_by(&:responsible_person) }
  end

  def new
    @daily_report = DailyReport.new
    @responsible_people = ["選択する", "西村", "土屋", "石川", "小笠原", "大原", "津田", "太我", "舜平", "竹本", "小野田", "藤田"]
  end

  def fetch_records
    responsible_person = params[:responsible_person]
    move_date = params[:move_date] || Date.today.to_s  # デフォルトを当日に設定

    # 指定した担当者かつ指定した日付の移動記録を **すべて取得**
    movement_records = MovementRecord.where(responsible_person: responsible_person, move_date: move_date)
                                     .select(:id, :model, :chassis_number, :pickup_location, :delivery_location)

    render json: movement_records
  end

  def create
    if params[:daily_report].blank?
      Rails.logger.error "daily_report パラメータがありません: #{params.inspect}"
      flash[:alert] = "フォームのデータが正しく送信されませんでした。"
      redirect_to new_daily_report_path and return
    end
  
    params[:daily_report][:responsible_person] = params[:responsible_person] if params[:daily_report][:responsible_person].blank?
    params[:daily_report][:absence_reason] = params[:absence_reason] if params[:daily_report][:absence_reason].blank?
  
    # ✅ `movement_records` を取得
    movement_records = MovementRecord.where(responsible_person: params[:responsible_person], move_date: params[:daily_report][:move_date])
  
    if movement_records.exists?
      params[:daily_report][:movement_record_id] = movement_records.first.id  # ✅ 最初のレコードをセット
      params[:daily_report][:travel_distance] = movement_records.sum { |record| (record.arrival_distance.to_i - record.departure_distance.to_i).abs }
    else
      # ✅ **移動記録がない場合は、最低限の情報で保存（出勤扱い）**
      params[:daily_report][:movement_record_id] = nil  # `nil` 許可済み
      params[:daily_report][:travel_distance] = 0
      params[:daily_report][:fuel_fee] = 0
      params[:daily_report][:toll_fee] = 0
      params[:daily_report][:transportation_fee] = 0
      params[:daily_report][:lodging_fee] = 0
    end
  
    @daily_report = DailyReport.new(daily_report_params)
  
    if @daily_report.save
      redirect_to daily_reports_path, notice: "日報が作成されました。"
    else
      Rails.logger.error "バリデーションエラー: #{@daily_report.errors.full_messages.join(', ')}"
      flash.now[:alert] = "入力に誤りがあります。修正してください。"
      render :new, status: :unprocessable_entity
    end
  end
  
  

  def show
  end

  def edit
  end

  def update
    movement_record = MovementRecord.find_by(id: params[:daily_report][:movement_record_id])

    if movement_record
      params[:daily_report][:travel_distance] = (movement_record.arrival_distance.to_i - movement_record.departure_distance.to_i).abs
    end

    if @daily_report.update(daily_report_params)
      redirect_to daily_report_path(@daily_report), notice: "日報が更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @daily_report.destroy
    redirect_to daily_reports_path, notice: "日報が削除されました。"
  end

  private

  def daily_report_params
    params.require(:daily_report).permit(:move_date, :responsible_person, :attendance_status,
                                         :start_time, :end_time, :work_content, :work_content_other,
                                         :absence_reason, :absence_reason_other, :remarks,
                                         :fuel_fee, :toll_fee, :transportation_fee, :lodging_fee,
                                         :movement_record_id, :travel_distance)  # ✅ travel_distance を追加
  end

  def set_daily_report
    @daily_report = DailyReport.find(params[:id])
  end
end
