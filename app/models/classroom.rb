class Classroom < ApplicationRecord
  belongs_to :teacher, class_name: 'User', foreign_key: 'teacher_id'
  belongs_to :workshop
  has_many :classroom_students
  has_many :students, through: :classroom_students, source: :user
  has_many :class_sessions, dependent: :destroy

  accepts_nested_attributes_for :class_sessions, allow_destroy: true

  validates :teacher, presence: true
  validates :workshop_id, presence: true, unless: -> { workshop.blank? }
  validate :teacher_must_be_admin
  validates :status, inclusion: { in: %w[Abierto Completo Finalizado] }

  validate :limit_students  # Check on both create and update

  before_save :update_final_student_count, if: -> { status_changed? && status == 'Finalizado' }
  before_update :update_student_roles, if: -> { status_changed? && status == 'Finalizado' }
  after_save :update_status_if_full

  def to_label
    "Aula #{id}: #{status}"  # Customize display
  end

  def total_cost
    students_count * price_per_student
  end

  def next_session_start_time
    next_session = class_sessions.where("session_date >= ?", Date.today).order(:session_date, :start_time).first
    next_session&.start_datetime
  end

  private

  def update_status_if_full
    if students.count >= 11 && status != 'Completo'
      update_column(:status, 'Completo')
    elsif students.count < 11 && status != 'Abierto'
      update_column(:status, 'Abierto')
    end
  end

  def limit_students
    if students.count >= 11 && status == 'Completo'
      errors.add(:base, 'El aula está completa y no puede aceptar más estudiantes.')
    end
  end

  def update_student_roles
    students.each do |student|
      student.update(role: 'Coder')
    end
  end

  def teacher_must_be_admin
    errors.add(:teacher_id, "must be an admin") unless teacher&.admin?
  end

  def update_final_student_count
    self.final_student_count = students.count
  end
end
