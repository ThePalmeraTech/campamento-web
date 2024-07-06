class User < ApplicationRecord
  attr_accessor :skip_password_validation, :uploading_second_payment

  belongs_to :workshop, optional: true
  has_many :classroom_students, dependent: :destroy
  has_many :classrooms, through: :classroom_students
  has_one_attached :full_payment_proof
  has_one_attached :reservation_payment_proof
  has_one_attached :second_payment_proof

  validate :at_least_one_payment_proof, unless: :uploading_second_payment?
  validate :must_have_active_classroom, if: -> { role == 'estudiante' }
  validate :validate_payment_proof_mime_type, unless: :uploading_second_payment?

  has_many :lesson_completions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :set_default_approved

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 7 }, unless: -> { skip_password_validation || uploading_second_payment? }
  validates :password_confirmation, presence: true, unless: -> { skip_password_validation || uploading_second_payment? }
  validates :phone, presence: true
  validates :workshop_id, presence: true

  validate :unique_email, on: :create

  def admin?
    role == 'admin'
  end

  def estudiante?
    role == 'estudiante'
  end

  def coder?
    role == 'coder'
  end

  def uploading_second_payment?
    uploading_second_payment
  end

  private

  def unique_email
    if User.where(email: email).exists?
      errors.add(:email, 'ya está registrado en el sistema.')
    end
  end

  def at_least_one_payment_proof
    unless full_payment_proof.attached? || reservation_payment_proof.attached?
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
    errors.add(:second_payment_proof, 'must be a JPEG, PNG, or PDF file.') if second_payment_proof.attached? && !second_payment_proof.content_type.in?(%w(image/jpeg image/png application/pdf))
  end
end
