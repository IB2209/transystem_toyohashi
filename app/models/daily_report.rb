class DailyReport < ApplicationRecord
  validates :work_date, presence: true
  validates :responsible_person, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :work_content, presence: true
  validate :validate_work_content_other
  validate :end_time_after_start_time

  # 休みの選択肢
  DAY_OFF_OPTIONS = ["有給休暇", "半日有給", "公休", "忌引き", "欠勤", "遅刻", "早退"].freeze

  # 業務内容の選択肢
  WORK_CONTENT_OPTIONS = ["車両移動", "構内作業", "事務作業", "横乗り", "送迎", "大阪", "その他"].freeze

  private

  # "その他" が選択されたときに `work_content_other` が必要
  def validate_work_content_other
    if work_content == "その他" && work_content_other.blank?
      errors.add(:work_content_other, "を入力してください")
    end
  end

  # 退勤時間は出勤時間より後であるべき
  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?

    if end_time < start_time
      errors.add(:end_time, "は出勤時間より後である必要があります")
    end
  end
end
