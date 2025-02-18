class InEntry < ApplicationRecord
  has_one :out_entry, foreign_key: :chassis_number, primary_key: :chassis_number, dependent: :destroy
  belongs_to :movement_record, optional: true
  validates :chassis_number, uniqueness: { scope: :movement_record_id, message: "同じ車体番号の伝票が既に登録されています" }
  validates :entry_date, :driver_name, :company_name, presence: true
  validates :chassis_number, presence: { message: "車体番号を入力してください" },
                            uniqueness: { message: "この車体番号は既に登録されています" }
end
