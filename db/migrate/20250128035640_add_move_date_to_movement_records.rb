class AddMoveDateToMovementRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :movement_records, :move_date, :date
  end
end
