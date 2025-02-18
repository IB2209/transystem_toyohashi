class RemoveUniqueConstraintFromChassisNumberInPlans < ActiveRecord::Migration[6.1]
  def change
    remove_index :plans, :chassis_number if index_exists?(:plans, :chassis_number)
    add_index :plans, :chassis_number # 一意性制約なしでインデックスを追加
  end
end
