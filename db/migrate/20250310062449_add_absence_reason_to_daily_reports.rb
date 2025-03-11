class AddAbsenceReasonToDailyReports < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_reports, :absence_reason, :string
    add_column :daily_reports, :absence_reason_other, :string
  end
end
