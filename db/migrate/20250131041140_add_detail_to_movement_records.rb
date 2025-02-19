class AddDetailToMovementRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :movement_records, :fuel_fee_detail, :text
    add_column :movement_records, :toll_fee_detail, :text
    add_column :movement_records, :transportation_fee_detail, :text
    add_column :movement_records, :lodging_fee_detail, :text
  end
end
