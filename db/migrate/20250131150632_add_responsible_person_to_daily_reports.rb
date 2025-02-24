class AddResponsiblePersonToDailyReports < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_reports, :responsible_person, :string
  end
end
