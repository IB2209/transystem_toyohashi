class AddDetailsToMovementRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :movement_records, :request_type, :string
    add_column :movement_records, :vehicle_condition, :string
    add_column :movement_records, :lodging_fee, :integer
    add_column :movement_records, :transportation_fee, :integer
    add_column :movement_records, :fuel_amount, :integer
    
  end
end
