class InEntriesController < ApplicationController
  def index
    @in_entries = InEntry.includes(:out_entry).order(entry_date: :desc, id: :desc)
    @grouped_entries_by_month = @in_entries.group_by { |entry| entry.entry_date.beginning_of_month }.sort.reverse.to_h
    @monthly_in_count = @grouped_entries_by_month.transform_values(&:size)
  end

  def new
    @in_entry = InEntry.new(entry_date: Date.today)
  end

  def confirm
    @in_entry = InEntry.new(process_params(in_entry_params))
    respond_to do |format|
      if @in_entry.valid?
        format.html { render :confirm }
        format.turbo_stream { render :confirm }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def create
    @in_entry = InEntry.new(in_entry_params)
    if params[:back]
      render :new
    elsif @in_entry.save
      respond_to do |format|
        format.html { redirect_to success_in_entries_path, notice: "送信完了しました。" }
        format.turbo_stream { redirect_to success_in_entries_path, notice: "送信完了しました。" }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
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
    if @in_entry.update(in_entry_params)
    respond_to do |format|
      format.html { redirect_to in_entries_path, notice: "入庫データを更新しました。" }
      format.turbo_stream { redirect_to in_entries_path, notice: "入庫データを更新しました。" }
    end
  else
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.turbo_stream { render :edit, status: :unprocessable_entity }
    end
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
