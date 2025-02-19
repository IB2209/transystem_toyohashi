class AddMovementRecordIdToOutEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :out_entries, :movement_record_id, :integer
    add_index :out_entries, :movement_record_id
  end
end
