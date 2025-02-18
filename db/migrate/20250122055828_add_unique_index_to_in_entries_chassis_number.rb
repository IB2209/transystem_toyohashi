class AddUniqueIndexToInEntriesChassisNumber < ActiveRecord::Migration[8.0]
  def change
    add_index :in_entries, :chassis_number, unique: true
  end
end
