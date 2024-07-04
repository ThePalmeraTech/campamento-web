class Classroom < ApplicationRecord
  belongs_to :teacher, class_name: 'User', foreign_key: 'teacher_id'
  belongs_to :workshop
  has_many :classroom_students
  has_many :students, through: :classroom_students, source: :user
  has_many :class_sessions, dependent: :destroy

  accepts_nested_attributes_for :class_sessions, allow_destroy: true

  validates :teacher, presence: true
  validates :workshop_id, presence: true, unless: -> { workshop.blank? }
  validates :regular_price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, presence: true
  validates :price_per_student, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[Abierto Completo Finalizado] }
  validate :valid_status_transition, if: :status_changed?
  before_save :calculate_total_price
  after_save :update_student_roles, if: -> { saved_change_to_status? && status == 'Finalizado' }


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

  def calculate_total_price
    if regular_price.present?
      if discount_percentage.present? && discount_percentage > 0
        self.price_per_student = regular_price - (regular_price * (discount_percentage / 100.0))
      else
        self.price_per_student = regular_price
      end
    end
  end

  def teacher_must_be_admin
    errors.add(:teacher_id, "must be an admin") unless teacher&.admin?
  end



  def valid_status_transition
    if status == 'Finalizado' && !%w[Abierto Completo].include?(status_was)
      errors.add(:status, "can only be set to 'Finalizado' if it was previously 'Abierto' or 'Completo'")
    end
  end


  def update_student_roles
    students.each do |student|
      student.update(role: 'Coders') unless student.role == 'Coders'
    end
  end

end
