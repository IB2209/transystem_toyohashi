class InEntry < ApplicationRecord
  has_many :out_entries, foreign_key: :in_entry_id, dependent: :nullify # ✅ `has_many` に変更
  belongs_to :movement_record, optional: true

  validates :chassis_number, uniqueness: { scope: [:entry_date, :movement_record_id], message: "同じ車体番号の伝票が同じ日に既に登録されています" }
  validates :entry_date, :driver_name, :company_name, presence: true
  validates :chassis_number, presence: { message: "車体番号を入力してください" }

  # 🚀 **保存後に出庫データの関連をリセット**
  after_save :reset_old_out_entries

  private

# 🔥 `in_entry_id` を最新の `InEntry` に変更するのではなく、適切な `OutEntry` を維持する
def reset_old_out_entries
  out_entries.each do |out_entry|
    if out_entry.entry_date < entry_date
      Rails.logger.info "⚠️ 出庫データ (ID: #{out_entry.id}) は新しい入庫データより過去の日付なので変更しない"
    else
      Rails.logger.info "🔄 出庫データ (ID: #{out_entry.id}) の `in_entry_id` を #{id} に更新"
      out_entry.update!(in_entry_id: id)
    end
  end
end
end