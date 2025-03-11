class AddRequestTypeToDailyReports < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_reports, :request_type, :string
  end
end
