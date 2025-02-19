class AddLodgingAndTransportationToMovementRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :movement_records, :lodging_fee_type, :string
    add_column :movement_records, :transportation_fee_type, :string
  end
end
