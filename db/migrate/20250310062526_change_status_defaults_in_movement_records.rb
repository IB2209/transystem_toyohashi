class ChangeStatusDefaultsInMovementRecords < ActiveRecord::Migration[7.2]
  def change
    change_column_default :movement_records, :status, false
    change_column_default :movement_records, :status_1, false
    change_column_default :movement_records, :status_2, false
  end
end
