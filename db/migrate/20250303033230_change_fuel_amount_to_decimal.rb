class ChangeFuelAmountToDecimal < ActiveRecord::Migration[7.2]
  def change
    change_column :movement_records, :fuel_amount, :decimal, precision: 10, scale: 2
  end
end
