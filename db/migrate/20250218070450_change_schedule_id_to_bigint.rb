class ChangeScheduleIdToBigint < ActiveRecord::Migration[6.1]
  def change
    change_column :movement_records, :schedule_id, :bigint
  end
end
