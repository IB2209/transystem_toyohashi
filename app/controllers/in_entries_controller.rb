class InEntriesController < ApplicationController
  def index
    @in_entries = InEntry.includes(:out_entries, :movement_record).order(entry_date: :desc, id: :desc)
    @grouped_entries_by_month = @in_entries.group_by { |entry| entry.entry_date.beginning_of_month }.sort.reverse.to_h
    @monthly_in_count = @grouped_entries_by_month.transform_values(&:size)
  end

  def new
    @in_entry = InEntry.new(entry_date: Date.today)
  end

  def confirm
    @in_entry = InEntry.new(process_params(in_entry_params))
    render :confirm unless @in_entry.valid?
  end

  def create
    @in_entry = InEntry.new(process_params(in_entry_params))
  
    if params[:back]
      render :new
    elsif @in_entry.save
      Rails.logger.info "✅ InEntry が保存されました: #{@in_entry.inspect}"
      redirect_to success_in_entries_path, notice: "送信完了しました。"
    else
      Rails.logger.error "❌ InEntry の保存に失敗: #{@in_entry.errors.full_messages.join(', ')}"
      flash.now[:alert] = @in_entry.errors.full_messages.join(", ")
      render :new
    end
  end
  

  # 送信完了ページ
  def success
  end

  def edit
    @in_entry = InEntry.find(params[:id])
  end

  def update
    @in_entry = InEntry.find(params[:id])
    processed_params = process_params(in_entry_params)
  
    if @in_entry.update(processed_params)
      redirect_to in_entries_path, notice: "入庫データを更新しました。"
    else
      render :edit
    end
  end
  

  def show
    @in_entry = InEntry.find(params[:id])
  end
  
  def destroy
    @in_entry = InEntry.find(params[:id])
    @in_entry.destroy
    redirect_to in_entries_path, notice: "削除が完了しました。"
  end

  private

  def in_entry_params
    params.require(:in_entry).permit(:company_name, :radio_company_name, :driver_name, :model, :radio_model, :chassis_number, :pickup_location, :radio_pickup_location, :has_abnormality, :message, :entry_date)
  end  

  def process_params(params)
    params[:company_name] = params[:company_name].presence || params[:radio_company_name]
    params[:model] = params[:model].presence || params[:radio_model]
    params[:pickup_location] = params[:pickup_location].presence || params[:radio_pickup_location]
    params
  end
end
