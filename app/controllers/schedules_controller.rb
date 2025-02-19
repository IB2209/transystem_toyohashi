class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

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
        @schedule.plan_id = plan.id
        @schedule.model = plan.model
        @schedule.chassis_number = plan.chassis_number
        @schedule.pickup_location = plan.pickup_location
        @schedule.delivery_location = plan.delivery_location
        @schedule.schedule_date = plan.move_date || DateTime.now.change({ hour: 9, min: 0 })
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
      # Planが存在する場合のみ更新
      if @schedule.plan.present?
        @schedule.plan.update(scheduled: true)
      end
  
      redirect_to schedules_path, notice: 'スケジュールが作成されました。'
    else
      flash.now[:alert] = @schedule.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
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
      # Planが存在する場合のみ更新
      @schedule.plan&.update(scheduled: false)
      redirect_to schedules_path, notice: 'スケジュールが削除されました。'
    else
      redirect_to schedules_path, alert: 'スケジュールの削除に失敗しました。'
    end
  end

  def set_schedule
    @schedule = Schedule.find_by(id: params[:id])
    redirect_to schedules_path, alert: 'スケジュールが見つかりません。' if @schedule.nil?
  end
  

  private

  def schedule_params
    params.require(:schedule).permit(:plan_id, :schedule_date, :responsible_person, :other_responsible_person, :comment)
  end

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end
end
