class CreateOutEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :out_entries do |t|
      t.string :company_name
      t.string :driver_name
      t.string :model
      t.string :chassis_number
      t.string :delivery_location
      t.boolean :has_abnormality
      t.text :message
      t.date :entry_date

      t.timestamps
    end
  end
end
