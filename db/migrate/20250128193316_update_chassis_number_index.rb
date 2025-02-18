class UpdateChassisNumberIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :in_entries, :chassis_number # 現在の一意性制約を削除
    add_index :in_entries, [:movement_record_id, :chassis_number], unique: true # 新しい制約を追加
  end
end
