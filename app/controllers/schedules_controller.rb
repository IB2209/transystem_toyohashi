class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy, :depart, :arrive]

  def index
    
    # 完了していないスケジュールのみ取得し、日付順にソート
    schedules = Schedule.where(is_completed: [false, nil]).order(schedule_date: :asc, created_at: :asc)
    
    # 日付ごとにグループ化
    @grouped_schedules_by_date = Schedule.where(is_completed: false).order(schedule_date: :asc).group_by { |schedule| schedule.schedule_date.to_date }
    @grouped_schedules_by_date = schedules.group_by { |schedule| schedule.schedule_date&.to_date }
    
  end

  def new
    @schedule = Schedule.new(responsible_person: "未定")
    if params[:plan_id].present?
      begin
        plan = Plan.find(params[:plan_id])
        @schedule.assign_attributes(
          plan_id: plan.id,
          model: plan.model,
          chassis_number: plan.chassis_number,
          pickup_location: plan.pickup_location,
          delivery_location: plan.delivery_location,
          comment: plan.comment,
          schedule_date: plan.move_date || DateTime.now.change(hour: 9, min: 0)
        )

        last_movement = MovementRecord.where(chassis_number: plan.chassis_number).order(created_at: :desc).first
        if last_movement.present?
          @schedule.departure_distance = last_movement.arrival_distance
          @schedule.departure_time = last_movement.arrival_time
        end

      rescue ActiveRecord::RecordNotFound
        redirect_to plans_path, alert: '指定された伝票が見つかりませんでした。'
      end
    end
  end

  def create
    responsible_person = if schedule_params[:responsible_person] == "その他"
                           schedule_params[:other_responsible_person]
                         else
                           schedule_params[:responsible_person]
                         end

    @schedule = Schedule.new(schedule_params.except(:other_responsible_person))
    @schedule.responsible_person = responsible_person

    if @schedule.save
      @schedule.plan&.update(scheduled: true) # Planのスケジュール済みを更新
      redirect_to schedules_path, notice: 'スケジュールが作成されました。'
    else
      flash.now[:alert] = @schedule.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def depart
    if @schedule.update(departure_distance: params[:departure_distance], departure_time: Time.current)
      redirect_to schedules_path, notice: "出発が記録されました。"
    else
      redirect_to schedules_path, alert: "出発距離の保存に失敗しました。"
    end
  end

  def arrive
    if @schedule.update(arrival_distance: params[:arrival_distance], arrival_time: Time.current)
    # 到着時刻を取得
    arrival_time = @schedule.arrival_time || Time.current

    # 出発時刻を取得
    departure_time = @schedule.departure_time || Time.current
    
    movement_record = MovementRecord.create!(
      schedule_id: @schedule.id,                          # 紐付くスケジュールID
      responsible_person: @schedule.responsible_person,  # 担当者名
      model: @schedule.model,                            # 型式
      chassis_number: @schedule.chassis_number,          # 車体番号
      pickup_location: @schedule.pickup_location,        # 引取先
      delivery_location: @schedule.delivery_location,    # 納車先
      departure_distance: @schedule.departure_distance,  # 出発時走行距離
      arrival_distance: @schedule.arrival_distance,      # 到着時走行距離
      move_date: @schedule.schedule_date,                # 移動日（スケジュール日）
      departure_hour: @schedule.departure_time&.hour,    # 出発時刻（時）
      departure_minute: @schedule.departure_time&.min,   # 出発時刻（分）
      arrival_hour: @schedule.arrival_time&.hour,        # 到着時刻（時）
      arrival_minute: @schedule.arrival_time&.min        # 到着時刻（分）
    )

    # 🚗 納車先が「豊橋プール」の場合は、自動的に入庫データ（InEntry）を作成
    if movement_record.delivery_location == "豊橋プール"
      # 同じ車体番号と移動日で既に入庫データが存在しない場合のみ作成
      unless InEntry.exists?(chassis_number: movement_record.chassis_number, entry_date: movement_record.move_date)
        InEntry.create!(
          entry_date: movement_record.move_date,              # 入庫日 = 移動日
          company_name: "コックス豊橋",                                   # 空欄（必要に応じて後で入力）
          driver_name: movement_record.responsible_person,                                    # 空欄
          model: movement_record.model,                       # 型式
          chassis_number: movement_record.chassis_number,     # 車体番号
          pickup_location: movement_record.pickup_location,   # 引取先
          has_abnormality: movement_record.has_abnormality,                             # 異常なし（仮）
          message: movement_record.message,                                        # メッセージ空欄
          movement_record_id: movement_record.id              # MovementRecord と関連付け
        )
      end
    end

    if movement_record.pickup_location == "豊橋プール"
      # 同じ車体番号と移動日で既に入庫データが存在しない場合のみ作成
      unless OutEntry.exists?(chassis_number: movement_record.chassis_number, entry_date: movement_record.move_date)
        OutEntry.create!(
          entry_date: movement_record.move_date,              # 入庫日 = 移動日
          company_name: "コックス豊橋",                         # 空欄（必要に応じて後で入力）
          driver_name: movement_record.responsible_person,    # 空欄
          model: movement_record.model,                       # 型式
          chassis_number: movement_record.chassis_number,     # 車体番号
          delivery_location: movement_record.delivery_location,# 納車先
          has_abnormality: movement_record.has_abnormality,   # 異常なし（仮）
          message: movement_record.message,                   # メッセージ空欄
          movement_record_id: movement_record.id              # MovementRecord と関連付け
        )
      end
    end

    # スケジュールを完了済みにする（スケジュール一覧から除外される）
    @schedule.update(is_completed: true)

    # 移動記録ページへリダイレクト
    redirect_to movement_records_path, notice: "到着が記録され、移動記録に移動しました。"
  else
    # 失敗時の処理
    redirect_to schedules_path, alert: "到着距離の保存に失敗しました。"
  end
end

  def edit
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to schedules_path, notice: 'スケジュールが更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    if @schedule.destroy
      @schedule.plan&.update(scheduled: false) # Planのスケジュール済みを解除
      redirect_to schedules_path, notice: 'スケジュールが削除されました。'
    else
      redirect_to schedules_path, alert: 'スケジュールの削除に失敗しました。'
    end
  end

  private

  def set_schedule
    @schedule = Schedule.find_by(id: params[:id])
    redirect_to schedules_path, alert: 'スケジュールが見つかりません。' if @schedule.nil?
  end

  def schedule_params
    params.require(:schedule).permit(:plan_id, :schedule_date, :responsible_person, :other_responsible_person, :comment)
  end
end
