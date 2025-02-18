class AddRadioFieldsToInEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :in_entries, :radio_company_name, :string
    add_column :in_entries, :radio_model, :string
    add_column :in_entries, :radio_pickup_location, :string
  end
end
