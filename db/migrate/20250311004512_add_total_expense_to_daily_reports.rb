class AddTotalExpenseToDailyReports < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_reports, :total_expense, :integer
  end
end
