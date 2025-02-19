class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.string :model
      t.string :chassis_number
      t.string :pickup_location
      t.string :delivery_location
      t.date :move_date
      t.text :comment
      t.text :issue_detail

      t.timestamps
    end
  end
end
