class AddScheduledToPlans < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:plans, :scheduled)
      add_column :plans, :scheduled, :boolean, default: false, null: false
    end
  end
end
