class DailyReportsController < ApplicationController
  def index
    @daily_reports = MovementRecord.where(move_date: Date.today).order(:responsible_person)
  end

  def new
    @daily_report = DailyReport.new
    @responsible_people = ["西村", "土屋", "石川", "小笠原", "大原", "津田", "太我", "舜平", "竹本", "小野田"]
  end

  def fetch_records
    responsible_person = params[:responsible_person]

    # 指定した担当者の移動記録を取得
    movement_records = MovementRecord.where(responsible_person: responsible_person).select(:id, :model, :chassis_number, :pickup_location, :delivery_location)

    render json: movement_records
  end

  def create
    @daily_report = DailyReport.new(daily_report_params)

    if @daily_report.save
      redirect_to daily_reports_path, notice: "日報が作成されました。"
    else
      @responsible_people = ["西村", "土屋", "石川", "小笠原", "大原", "津田", "太我", "舜平", "竹本", "小野田"]
      render :new
    end
  end

  private

  def daily_report_params
    params.require(:daily_report).permit(:responsible_person, movement_records_attributes: [:id, :model, :chassis_number, :pickup_location, :delivery_location, :move_date, :request_type, :vehicle_condition, :toll_fee_type, :toll_fee, :fuel_fee_type, :fuel_fee, :lodging_fee, :transportation_fee, :fuel_amount, :lodging_fee_type, :transportation_fee_type])
  end
end
