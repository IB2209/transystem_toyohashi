class AddMovementRecordToDailyReports < ActiveRecord::Migration[7.2]
  def change
    add_reference :daily_reports, :movement_record, null: false, foreign_key: true
  end
end
