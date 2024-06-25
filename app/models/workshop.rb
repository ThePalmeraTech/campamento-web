class Workshop < ApplicationRecord
  # Assuming each workshop could be linked to many classrooms and each classroom has multiple students
  has_many :classrooms
  has_many :lessons, dependent: :destroy
  has_many :students, through: :classrooms, source: :students  # Ensure Classroom model defines has_many :students

  accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true

  def progress_for(user)
    total_lessons = lessons.count
    completed_lessons = lessons.joins(:completions).where(lesson_completions: { user: user }).count
    total_lessons > 0 ? (completed_lessons.to_f / total_lessons * 100).round : 0
  end
end
