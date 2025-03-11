class RenameWorkDateToMoveDateInDailyReports < ActiveRecord::Migration[7.2]
  def change
    rename_column :daily_reports, :work_date, :move_date
  end
end
