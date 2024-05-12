class Lesson < ApplicationRecord
  belongs_to :workshop
  validates :title, presence: true
end
