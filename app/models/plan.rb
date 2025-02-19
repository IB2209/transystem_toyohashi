class Plan < ApplicationRecord
  validates :chassis_number, presence: true
  validate :chassis_number_and_location_rules

  private

  # ✅ **車番の登録ルールを適用**
  def chassis_number_and_location_rules
    return if chassis_number.blank? || move_date.blank? || allow_duplicate_chassis?

    # **同じ車番 & 同じ移動期日のデータが既にある場合はNG**
    if Plan.where(chassis_number: chassis_number, move_date: move_date).where.not(id: id).exists?
      errors.add(:chassis_number, "この車番の移動期日は既に登録されています")
      return
    end

    # **往復パターン（pickup ⇆ delivery）は登録OK**
    return if Plan.where(chassis_number: chassis_number, pickup_location: delivery_location, delivery_location: pickup_location).exists?

    # **完全一致（pickup_location & delivery_locationが同じ）の場合はNG**
    if Plan.where(chassis_number: chassis_number, pickup_location: pickup_location, delivery_location: delivery_location, move_date: move_date).where.not(id: id).exists?
      errors.add(:chassis_number, "この車番の引取先・納車先・移動期日の組み合わせは既に登録されています")
    end
  end

  # ✅ **特定の条件なら車番の重複を許可**
  def allow_duplicate_chassis?
    return false if exists_in_unshipped_list? # ✅ 未出庫一覧にある車両は重複NG
    true
  end

  # ✅ **未出庫一覧にある車番で、納車先が豊橋プールの場合はNG**
  def exists_in_unshipped_list?
    InEntry.where(chassis_number: chassis_number)
           .where.not(chassis_number: OutEntry.pluck(:chassis_number)) # 🚀 出庫されていないもののみ取得
           .exists?
  end
end
