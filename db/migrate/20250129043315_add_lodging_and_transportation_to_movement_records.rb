class AddLodgingAndTransportationToMovementRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :movement_records, :lodging_fee_type, :string
    add_column :movement_records, :transportation_fee_type, :string
  end
end
