class AddRadioDeliveryLocationToOutEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :out_entries, :radio_delivery_location, :string
  end
end
