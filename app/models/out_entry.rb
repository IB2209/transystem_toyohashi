class OutEntry < ApplicationRecord
  belongs_to :in_entry, foreign_key: :in_entry_id, optional: true
  belongs_to :movement_record, optional: true

  after_initialize :set_default_values, if: :new_record?

  private

  def set_default_values
    self.has_abnormality = false if has_abnormality.nil?
  end
end
