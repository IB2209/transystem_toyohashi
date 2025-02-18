class RemoveUniqueConstraintFromPlans < ActiveRecord::Migration[7.0]
  def change
    remove_index :plans, :chassis_number # 一意性制約を解除
    add_index :plans, :chassis_number   # 通常のインデックスを追加（必要に応じて）
  end
end
