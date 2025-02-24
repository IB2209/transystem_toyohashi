class AddDetailToMovementRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :movement_records, :fuel_fee_detail, :text
    add_column :movement_records, :toll_fee_detail, :text
    add_column :movement_records, :transportation_fee_detail, :text
    add_column :movement_records, :lodging_fee_detail, :text
  end
end
