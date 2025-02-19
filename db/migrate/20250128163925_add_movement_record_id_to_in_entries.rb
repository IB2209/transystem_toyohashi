class AddMovementRecordIdToInEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :in_entries, :movement_record_id, :integer
    add_index :in_entries, :movement_record_id
  end
end
