class InEntry < ApplicationRecord
  has_one :out_entry, foreign_key: :chassis_number, primary_key: :chassis_number, dependent: :destroy
  belongs_to :movement_record, optional: true

  # ✅ `entry_date` が同じ場合のみ `chassis_number` をユニークにする
  validates :chassis_number, uniqueness: { scope: [:entry_date, :movement_record_id], message: "同じ車体番号の伝票が同じ日に既に登録されています" }

  validates :entry_date, :driver_name, :company_name, presence: true
  validates :chassis_number, presence: { message: "車体番号を入力してください" }
end
