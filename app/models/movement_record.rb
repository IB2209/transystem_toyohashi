class MovementRecord < ApplicationRecord
  belongs_to :schedule
  has_one :out_entry, dependent: :destroy
  has_one :in_entry, dependent: :destroy

  # **時間のバリデーション**
  validates :departure_hour, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24 }
  validates :departure_minute, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 60 }
  validates :arrival_hour, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24 }
  validates :arrival_minute, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 60 }

  # **異常のデフォルト値を false に設定**
  attribute :has_abnormality, :boolean, default: false

  # **未出庫一覧のバリデーション**
  validate :validate_movement_conditions, on: :create # 新規登録時のみ実行

  private

  # 🚀 **移動記録のバリデーション（新規登録時のみ）**
  def validate_movement_conditions
    return if schedule.nil? || chassis_number.blank?

    Rails.logger.info "🚀 バリデーション開始: MovementRecord ##{id} | 車番: #{chassis_number} | 引取先: #{pickup_location} | 納車先: #{delivery_location}"

    # ✅ **未出庫一覧にない `chassis_number` で `引取先` が `豊橋プール` の場合、登録NG**
    if pickup_location == "豊橋プール" && !exists_in_unshipped_list?
      Rails.logger.warn "❌ #{chassis_number} は未出庫一覧に存在しません"
      errors.add(:chassis_number, "未出庫一覧にない車両のため、豊橋プールでの引取はできません")
      return
    end

    # ✅ **未出庫の `chassis_number` で `納車先` が `豊橋プール` の場合、登録NG**
    if exists_in_unshipped_list? && delivery_location == "豊橋プール"
      Rails.logger.warn "❌ #{chassis_number} は未出庫だが納車先が豊橋プール"
      errors.add(:chassis_number, "未出庫の車番で納車先が豊橋プールの場合は登録できません")
      return
    end

    # ✅ **往復パターン（pickup ⇆ delivery）は登録OK**
    return if MovementRecord.where(chassis_number: chassis_number, pickup_location: delivery_location, delivery_location: pickup_location).exists?

    # ✅ **完全一致（pickup_location & delivery_location が同じ）の場合は登録NG（編集時は除外）**
    if MovementRecord.where(chassis_number: chassis_number, pickup_location: pickup_location, delivery_location: delivery_location)
                     .where.not(id: id) # 編集時は自分自身を除外
                     .exists?
      Rails.logger.warn "❌ #{chassis_number} は完全一致のデータが存在するためNG"
      errors.add(:chassis_number, "この車番の引取先・納車先の組み合わせは既に登録されています")
      return
    end

    Rails.logger.info "✅ バリデーション成功: MovementRecord ##{id} | 車番: #{chassis_number}"
  end

  # ✅ **未出庫の車両判定**
  def exists_in_unshipped_list?
    # `InEntry` に存在し、かつ `OutEntry` には存在しない `chassis_number` を「未出庫」と判定
    unshipped = InEntry.where(chassis_number: chassis_number)
                       .where.not(chassis_number: OutEntry.select(:chassis_number)) # 出庫済みのものを除外
                       .exists?

    Rails.logger.info "🔍 未出庫リストチェック: 車番=#{chassis_number} | 結果=#{unshipped ? '未出庫' : '出庫済み'}"
    unshipped
  end
end
