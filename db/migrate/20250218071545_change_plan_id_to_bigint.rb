class ChangePlanIdToBigint < ActiveRecord::Migration[6.1]
  def change
    change_column :schedules, :plan_id, :bigint
  end
end
