class AddDetailsToMovementRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :movement_records, :request_type, :string
    add_column :movement_records, :vehicle_condition, :string
    add_column :movement_records, :lodging_fee, :integer
    add_column :movement_records, :transportation_fee, :integer
    add_column :movement_records, :fuel_amount, :integer
    
  end
end
