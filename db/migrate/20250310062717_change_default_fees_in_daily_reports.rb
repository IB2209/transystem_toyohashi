class ChangeDefaultFeesInDailyReports < ActiveRecord::Migration[7.2]
  def change
    change_column_default :daily_reports, :fuel_fee, 0
    change_column_default :daily_reports, :toll_fee, 0
    change_column_default :daily_reports, :transportation_fee, 0
    change_column_default :daily_reports, :lodging_fee, 0
  end
end
