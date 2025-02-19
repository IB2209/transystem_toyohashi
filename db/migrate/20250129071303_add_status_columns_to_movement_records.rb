class AddStatusColumnsToMovementRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :movement_records,  :status_1, :boolean, default: false
    add_column :movement_records,  :status_2, :boolean, default: false
  end 
end
