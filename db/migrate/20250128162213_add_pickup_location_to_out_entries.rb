class AddPickupLocationToOutEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :out_entries, :pickup_location, :string
  end
end
