class CreateDailyReports < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_reports do |t|
      t.date :work_date
      t.string :employee_name
      t.datetime :start_time
      t.datetime :end_time
      t.string :day_off
      t.string :work_content
      t.string :work_content_other
      t.string :vehicle_model
      t.string :chassis_number
      t.string :pickup_location
      t.string :delivery_location
      t.integer :travel_distance
      t.integer :fuel_fee
      t.integer :toll_fee
      t.integer :transportation_fee
      t.integer :lodging_fee
      t.string :fuel_fee_type
      t.string :toll_fee_type
      t.string :transportation_fee_type
      t.string :lodging_fee_type
      t.integer :fuel_amount
      t.boolean :has_abnormality
      t.text :remarks
      t.boolean :status
      t.boolean :status_1
      t.boolean :status_2
      t.text :fuel_fee_detail
      t.text :toll_fee_detail
      t.text :transportation_fee_detail
      t.text :lodging_fee_detail

      t.timestamps
    end
  end
end
