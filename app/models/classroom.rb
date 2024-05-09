class Classroom < ApplicationRecord
  belongs_to :teacher, class_name: 'User'
  has_many :classroom_students
  has_many :students, through: :classroom_students, source: :user
  has_many :class_sessions, dependent: :destroy

  accepts_nested_attributes_for :class_sessions, allow_destroy: true

  validates :status, inclusion: { in: %w[Abierto En clase Finalizado] }
  validate :only_one_active_classroom, on: :create

  validate :limit_students, on: :create

  before_update :update_student_roles, if: -> { status_changed? && status == 'Finalizado' }

  private

  def only_one_active_classroom
    active_classroom = Classroom.where(status: ["Abierto", "En clase"]).first
    if active_classroom
      Rails.logger.debug "Active classroom found: #{active_classroom.id}"
      errors.add(:base, "Ya existe un aula activa.")
    end
  end


  def limit_students
    if students.count >= 9
      errors.add(:base, 'El aula no puede tener más de 9 estudiantes.')
    end
  end

  def update_student_roles
    students.each do |student|
      student.update(role: 'Coder')
    end
  end
end
