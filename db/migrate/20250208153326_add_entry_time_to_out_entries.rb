class AddEntryTimeToOutEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :out_entries, :entry_hour, :integer
    add_column :out_entries, :entry_minute, :integer
  end
end
