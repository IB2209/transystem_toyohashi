class AddDepartureAndArrivalTimesToSchedules < ActiveRecord::Migration[7.2]
  def change
    add_column :schedules, :departure_time, :datetime
    add_column :schedules, :arrival_time, :datetime
  end
end
