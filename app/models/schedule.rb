class Schedule < ApplicationRecord
  belongs_to :plan
  validates :responsible_person, presence: true
  validates :schedule_date, presence: true
  validates :plan_id, presence: true
  delegate :model, :chassis_number, :pickup_location, :delivery_location, to: :plan, allow_nil: true
end
