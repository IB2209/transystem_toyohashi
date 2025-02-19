class AddHourAndMinuteToMovementRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :movement_records, :departure_hour, :integer, null: true
    add_column :movement_records, :departure_minute, :integer, null: true
    add_column :movement_records, :arrival_hour, :integer, null: true
    add_column :movement_records, :arrival_minute, :integer, null: true
  end
end
