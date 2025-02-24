class AddUniqueIndexToInEntriesChassisNumber < ActiveRecord::Migration[7.2]
  def change
    add_index :in_entries, :chassis_number, unique: true
  end
end
