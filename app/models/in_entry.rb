class InEntry < ApplicationRecord
  has_one :out_entry, foreign_key: :chassis_number, primary_key: :chassis_number, dependent: :nullify
  belongs_to :movement_record, optional: true

  # 🚀 `entry_date` が同じ場合のみ `chassis_number` をユニークにする
  validates :chassis_number, uniqueness: { scope: [:entry_date, :movement_record_id], message: "同じ車体番号の伝票が同じ日に既に登録されています" }

  validates :entry_date, :driver_name, :company_name, presence: true
  validates :chassis_number, presence: { message: "車体番号を入力してください" }

  # 🚀 **出庫データがすでに紐付いている場合、新しい `OutEntry` を紐付け不可**
  validate :only_one_out_entry_allowed

  private

  def only_one_out_entry_allowed
    if out_entry.present? && will_save_change_to_chassis_number?
      errors.add(:chassis_number, "この車体番号の入庫データには、すでに出庫データが存在します。")
    end
  end
end
