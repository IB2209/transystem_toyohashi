class UpdateTravelDistanceForExistingRecords < ActiveRecord::Migration[7.0]
  def up
    MovementRecord.find_each do |record|
      if record.departure_distance.present? && record.arrival_distance.present?
        record.update_columns(travel_distance: (record.arrival_distance - record.departure_distance).abs)
      else
        record.update_columns(travel_distance: 0)
      end
    end
  end

  def down
    MovementRecord.update_all(travel_distance: nil)
  end
end
