class Classroom < ApplicationRecord
  belongs_to :teacher, class_name: 'User'
  validates :teacher, presence: true
  validate :teacher_must_be_admin
  has_many :classroom_students
  has_many :students, through: :classroom_students, source: :user
  before_save :update_final_student_count, if: -> { status_changed? && status == 'Finalizado' }

  has_many :class_sessions, dependent: :destroy

  accepts_nested_attributes_for :class_sessions, allow_destroy: true

  validates :status, inclusion: { in: %w[Abierto Completo Finalizado] }
  validate :only_one_active_classroom, on: :create
  validate :limit_students, on: :create

  before_update :update_student_roles, if: -> { status_changed? && status == 'Finalizado' }
  after_save :update_status_if_full, unless: -> { status == 'Finalizado' }

  private

  def update_status_if_full
    if students.count >= 9 && status != 'En clase'
      update_column(:status, 'En clase')
    end
  end

  def only_one_active_classroom
    active_classroom = Classroom.where(status: ["Abierto", "En clase"]).first
    if active_classroom && status != 'Finalizado'
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


  # Validación personalizada para asegurar que el profesor sea admin
  def teacher_must_be_admin
    errors.add(:teacher_id, "must be an admin") unless teacher&.admin?
  end

  def update_final_student_count
    self.final_student_count = students.count
  end

end
