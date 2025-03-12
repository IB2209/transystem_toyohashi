class ChangeMovementRecordIdNullableOnDailyReports < ActiveRecord::Migration[7.0]
  def change
    change_column_null :daily_reports, :movement_record_id, true
  end
end
