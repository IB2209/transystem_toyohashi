class CreateMovementRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :movement_records do |t|
      t.references :schedule, null: false, foreign_key: true
      t.string :responsible_person
      t.string :model
      t.string :chassis_number
      t.string :pickup_location
      t.string :waypoint
      t.string :delivery_location
      t.datetime :departure_time
      t.datetime :arrival_time
      t.integer :departure_distance
      t.integer :arrival_distance
      t.string :toll_fee_type
      t.integer :toll_fee
      t.string :fuel_fee_type
      t.integer :fuel_fee
      t.boolean :has_abnormality
      t.text :message

      t.timestamps
    end
  end
end
