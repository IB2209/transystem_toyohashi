class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.string :model
      t.string :chassis_number
      t.string :pickup_location
      t.string :delivery_location
      t.datetime :schedule_date
      t.string :responsible_person
      t.text :note
      t.references :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
