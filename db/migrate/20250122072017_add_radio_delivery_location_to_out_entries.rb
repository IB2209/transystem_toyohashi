class AddRadioDeliveryLocationToOutEntries < ActiveRecord::Migration[7.2]
  def change
    add_column :out_entries, :radio_delivery_location, :string
  end
end
