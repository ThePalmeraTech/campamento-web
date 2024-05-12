class Workshop < ApplicationRecord
  belongs_to :classroom, optional: true
  has_many :lessons, dependent: :destroy

  accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true

end
