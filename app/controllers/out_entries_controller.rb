class OutEntriesController < ApplicationController
  
  def index
    @out_entries = OutEntry.includes(:in_entry).order(entry_date: :desc, id: :desc)
    @grouped_entries_by_month = @out_entries.group_by { |entry| entry.entry_date.beginning_of_month }.sort.reverse.to_h
    @monthly_out_count = @grouped_entries_by_month.transform_values(&:size)
  end

  def new
  @in_entries = InEntry.all
  @out_entry = OutEntry.new(entry_date: Date.today)

  if params[:chassis_number].present?
    in_entry = InEntry.find_by(chassis_number: params[:chassis_number])
    if in_entry
      @out_entry.assign_attributes(
        chassis_number: in_entry.chassis_number,
        radio_model: in_entry.radio_model,
        model: in_entry.model
      )
    else
      flash.now[:alert] = "該当する入庫情報が見つかりませんでした。"
    end
  end
end

def confirm
  @out_entry = OutEntry.new(out_entry_params)  # 修正

  if @out_entry.valid?
    render :confirm
  else
    @in_entries = InEntry.all
    render :new
  end
end


  def create
    processed_params = process_params(out_entry_params)
    @out_entry = OutEntry.new(processed_params)
  
    if @out_entry.save
      redirect_to success_out_entries_path, notice: "出庫情報が登録されました。"
    else
      Rails.logger.debug "エラー: #{@out_entry.errors.full_messages}"
      flash.now[:alert] = @out_entry.errors.full_messages.join(", ")
      @in_entries = InEntry.all # エラー時も入庫データを渡す
      render :new, status: :unprocessable_entity
    end
  end

  def success
  end
  


  def edit
    @out_entry = OutEntry.find(params[:id])
  end

  def update
    @out_entry = OutEntry.find(params[:id])
    processed_params = process_params(out_entry_params)  # process_params を適用
  
    if @out_entry.update(processed_params)
      redirect_to out_entries_path, notice: '出庫データを更新しました。'
    else
      flash.now[:alert] = @out_entry.errors.full_messages.join(", ")
      render :edit
    end
  end

  def show
    @in_entry = InEntry.find(params[:id])
  end
  


  def destroy
    @out_entry = OutEntry.find(params[:id])
    if @out_entry.destroy
      redirect_to out_entries_path, notice: "出庫データを削除しました。"
    else
      flash[:alert] = "出庫データの削除に失敗しました。"
      redirect_to out_entries_path
    end
  end
  


  private

  def out_entry_params
    params.require(:out_entry).permit(:company_name, :radio_company_name, :driver_name, :model, :radio_model, :chassis_number, :pickup_location, :radio_pickup_location, :delivery_location, :radio_delivery_location, :has_abnormality, :message, :entry_date)
  end
  

  def process_params(params)
    params.merge(
      company_name: params[:company_name].presence || params[:radio_company_name],
      model: params[:model].presence || params[:radio_model],
      delivery_location: params[:delivery_location].presence || params[:radio_delivery_location]
    )
  end
  
  
end

