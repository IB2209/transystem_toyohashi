class AddAttendanceStatusToDailyReports < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_reports, :attendance_status, :string
  end
end
