class OutEntry < ApplicationRecord
  belongs_to :in_entry, foreign_key: :movement_record_id, primary_key: :movement_record_id, optional: true
  belongs_to :movement_record, optional: true
  validates :chassis_number, presence: { message: "車体番号を入力してください" }
  
  after_initialize :set_default_values, if: :new_record?
  private

  def set_default_values
    self.has_abnormality = false if has_abnormality.nil?
  end
end
