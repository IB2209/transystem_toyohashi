class ChangeMoveDateToDatetimeInPlans < ActiveRecord::Migration[6.1]
  def change
    change_column :plans, :move_date, :datetime
  end
end
