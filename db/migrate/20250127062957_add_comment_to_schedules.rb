class AddCommentToSchedules < ActiveRecord::Migration[7.2]
  def change
    add_column :schedules, :comment, :string
  end
end
