class Classroom < ApplicationRecord
  belongs_to :teacher, class_name: 'User', foreign_key: 'teacher_id'
  belongs_to :workshop, optional: true  # Esto es correcto si la relación es opcional
  has_many :classroom_students
  has_many :students, through: :classroom_students, source: :user
  has_many :class_sessions, dependent: :destroy

  accepts_nested_attributes_for :class_sessions, allow_destroy: true

  validates :teacher, presence: true
  validates :workshop_id, presence: true, unless: -> { workshop.blank? }
  validate :teacher_must_be_admin
  validates :status, inclusion: { in: %w[Abierto Completo Finalizado] }

  validate :only_one_active_classroom, on: :create
  validate :limit_students, on: :create

  before_save :update_final_student_count, if: -> { status_changed? && status == 'Finalizado' }
  before_update :update_student_roles, if: -> { status_changed? && status == 'Finalizado' }
  after_save :update_status_if_full, unless: -> { status == 'Finalizado' }

  def to_label
    "Aula #{id}: #{status}"  # Ajusta esto según cómo deseas que se muestre
  end

  def total_cost
    students_count * price_per_student
  end

  def next_session_start_time
    next_session = class_sessions.where("session_date >= ?", Date.today).order(:session_date, :start_time).first
    next_session&.start_datetime  # Retorna nil si no hay próxima sesión
  end

  private

  def update_status_if_full
    if students.count >= 11 && status != 'En clase'
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
    if students.count >= 11
      errors.add(:base, 'El aula no puede tener más de 11 estudiantes.')
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
