class InEntry < ApplicationRecord
  has_one :out_entry, foreign_key: :movement_record_id, primary_key: :movement_record_id, dependent: :destroy
  belongs_to :movement_record, optional: true

  validates :chassis_number, presence: { message: "車体番号を入力してください" },
                            uniqueness: { scope: :movement_record_id, message: "同じ車体番号の伝票が既に登録されています" }
  validates :entry_date, :driver_name, :company_name, presence: true
end
