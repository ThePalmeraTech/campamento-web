class Lesson < ApplicationRecord
  belongs_to :workshop
  validates :title, presence: true
  has_many :completions, class_name: 'LessonCompletion', dependent: :destroy


  def next_lesson
    workshop.lessons.where('id > ?', id).order(:id).first
  end

end
