class AddDepartureAndArrivalDistanceToSchedules < ActiveRecord::Migration[7.2]
  def change
    add_column :schedules, :departure_distance, :integer
    add_column :schedules, :arrival_distance, :integer
  end
end
