class AddIsCompletedToSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :is_completed, :boolean, default: false
  end
end
