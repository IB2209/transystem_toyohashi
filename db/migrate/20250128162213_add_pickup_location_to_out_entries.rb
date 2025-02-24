class AddPickupLocationToOutEntries < ActiveRecord::Migration[7.2]
  def change
    add_column :out_entries, :pickup_location, :string
  end
end
