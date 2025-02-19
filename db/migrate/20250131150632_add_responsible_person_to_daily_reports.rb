class AddResponsiblePersonToDailyReports < ActiveRecord::Migration[8.0]
  def change
    add_column :daily_reports, :responsible_person, :string
  end
end
