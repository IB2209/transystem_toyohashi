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
    
      # 到着後に MovementRecord を作成
      movement_record = MovementRecord.create!(
        schedule_id: @schedule.id,
        responsible_person: @schedule.responsible_person,
        model: @schedule.model,
        chassis_number: @schedule.chassis_number,
        pickup_location: @schedule.pickup_location,
        delivery_location: @schedule.delivery_location,
        departure_distance: @schedule.departure_distance,
        arrival_distance: @schedule.arrival_distance,
        move_date: @schedule.schedule_date,
        departure_hour: @schedule.departure_time&.hour,
        departure_minute: @schedule.departure_time&.min,
        arrival_hour: @schedule.arrival_time&.hour,
        arrival_minute: @schedule.arrival_time&.min
      )

      # スケジュールを完了扱いにする（一覧から消える）
      @schedule.update(is_completed: true)

      redirect_to movement_records_path, notice: "到着が記録され、移動記録に移動しました。"
    else
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
