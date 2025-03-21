class AddInEntryIdToOutEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :out_entries, :in_entry_id, :integer
    add_index :out_entries, :in_entry_id
  end
end
