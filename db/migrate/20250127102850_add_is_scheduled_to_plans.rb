class AddIsScheduledToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :scheduled, :boolean, default: false, null: false
  end
end
