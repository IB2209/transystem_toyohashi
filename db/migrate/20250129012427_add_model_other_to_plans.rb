class AddModelOtherToPlans < ActiveRecord::Migration[7.2]
  def change
    add_column :plans, :model_other, :string
    add_column :plans, :pickup_other, :string
    add_column :plans, :delivery_other, :string
  end
end
