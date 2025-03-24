class DailyReport < ApplicationRecord
  has_many :movement_records, foreign_key: :responsible_person, primary_key: :responsible_person
  before_save :set_travel_distance

  def movement_records
    MovementRecord.where(responsible_person: responsible_person, move_date: move_date)
  end

  # **担当者の選択肢**
  RESPONSIBLE_PEOPLE = ["西村", "土屋", "石川", "小笠原", "大原", "津田", "太我", "舜平", "竹本", "小野田", "藤田"].freeze

  # **業務内容の選択肢**
  WORK_CONTENT_OPTIONS = ["自走", "構内作業", "事務作業", "横乗り", "送迎", "大阪", "その他"].freeze

  # **欠勤理由の選択肢**
  ABSENCE_REASON_OPTIONS = ["有給", "午前休", "午後休", "振休", "忌引", "公欠", "欠勤", "その他"].freeze

  # **バリデーション**
  validates :move_date, presence: true
  validates :responsible_person, presence: true, inclusion: { in: RESPONSIBLE_PEOPLE, message: "を選択してください" }
  validates :attendance_status, presence: true
  validates :start_time, presence: true, unless: -> { attendance_status == "欠勤" }
  validates :end_time, presence: true, unless: -> { attendance_status == "欠勤" }
  validates :work_content, presence: true, inclusion: { in: WORK_CONTENT_OPTIONS, message: "を選択してください" }, unless: -> { attendance_status == "欠勤" }
  validates :absence_reason, presence: true, if: -> { attendance_status == "欠勤" }
  validates :fuel_fee, :toll_fee, :transportation_fee, :lodging_fee, numericality: { greater_than_or_equal_to: 0 }

  validate :validate_work_content_other
  validate :validate_absence_reason_other
  validate :end_time_after_start_time

  validates :move_date, uniqueness: { scope: :responsible_person, message: "はこの担当者の日報がすでに登録されています" }

  before_save :calculate_total_expense

  private

  # **移動距離 (`travel_distance`) を計算**
  def set_travel_distance
    if movement_records.present?
      self.travel_distance = movement_records.sum(:travel_distance).to_i  # ✅ movement_records の travel_distance を合計
    else
      self.travel_distance = 0
    end
  end
  
  

  # **"その他" が選択されたときに `work_content_other` を必須にする**
  def validate_work_content_other
    if work_content == "その他" && work_content_other.blank?
      errors.add(:work_content_other, "を入力してください")
    end
  end

  # **"その他" が選択されたときに `absence_reason_other` を必須にする**
  def validate_absence_reason_other
    if absence_reason == "その他" && absence_reason_other.blank?
      errors.add(:absence_reason_other, "を入力してください")
    end
  end

  # **退勤時間は出勤時間より後である必要がある**
  def end_time_after_start_time
    return if start_time.blank? || end_time.blank? || attendance_status == "欠勤"

    if end_time < start_time
      errors.add(:end_time, "は出勤時間より後である必要があります")
    end
  end

  # **経費の合計を計算**
  def calculate_total_expense
    self.total_expense = fuel_fee.to_i + toll_fee.to_i + transportation_fee.to_i + lodging_fee.to_i
  end
end
