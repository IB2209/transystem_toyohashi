class AddUniqueIndexToDailyReports < ActiveRecord::Migration[7.2]
  def change
    add_index :daily_reports, [:move_date, :responsible_person], unique: true
  end
end
