class Lesson < ApplicationRecord
  belongs_to :workshop
  validates :title, presence: true
  has_many :completions, class_name: 'LessonCompletion', dependent: :destroy


  def next_lesson
    current_index = workshop.lessons.order(:id).index(self)
    workshop.lessons.order(:id)[current_index + 1]
  end


end
