class AddEntryTimeToOutEntries < ActiveRecord::Migration[7.2]
  def change
    add_column :out_entries, :entry_hour, :integer
    add_column :out_entries, :entry_minute, :integer
  end
end
