class AddTravelDistanceToMovementRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :movement_records, :travel_distance, :integer
  end
end
