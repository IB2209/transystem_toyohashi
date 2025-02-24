class AddMoveDateToMovementRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :movement_records, :move_date, :date
  end
end
