class AddStatusToMovementRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :movement_records, :status, :boolean, default: false
  end
  
end
