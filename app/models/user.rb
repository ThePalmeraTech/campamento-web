class User < ApplicationRecord
  belongs_to :workshop, optional: true
  attr_accessor :payment_option

  has_many :classroom_students, dependent: :destroy
  has_many :classrooms, through: :classroom_students
  has_one_attached :full_payment_proof
  has_one_attached :reservation_payment_proof

  validate :at_least_one_payment_proof
  validate :must_have_active_classroom, if: -> { role == 'estudiante' }
  validate :validate_payment_proof_mime_type

  has_many :lesson_completions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :set_default_approved

  def admin?
    role == 'admin'
  end

  def estudiante?
    role == 'estudiante'
  end

  def coder?
    role == 'coder'
  end

  private

  def at_least_one_payment_proof
    if full_payment_proof.blank? && reservation_payment_proof.blank?
      errors.add(:base, "Debe subir al menos un comprobante de pago: completo o de reserva.")
    end
  end

  def must_have_active_classroom
    unless Classroom.exists?(status: ['Abierto', 'En clase'])
      errors.add(:base, 'No se puede asignar el rol de estudiante sin un aula activa.')
    end
  end

  def set_default_approved
    self.update(approved: false) unless self.admin?
  end

  def validate_payment_proof_mime_type
    errors.add(:full_payment_proof, 'must be a JPEG, PNG, or PDF file.') if full_payment_proof.attached? && !full_payment_proof.content_type.in?(%w(image/jpeg image/png application/pdf))
    errors.add(:reservation_payment_proof, 'must be a JPEG, PNG, or PDF file.') if reservation_payment_proof.attached? && !reservation_payment_proof.content_type.in?(%w(image/jpeg image/png application/pdf))
  end
end
