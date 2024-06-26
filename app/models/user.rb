class User < ApplicationRecord
  attr_accessor :payment_option

  has_many :classroom_students, dependent: :destroy
  has_many :classrooms, through: :classroom_students
  has_one_attached :full_payment_proof
  has_one_attached :reservation_payment_proof
  validate :at_least_one_payment_proof
  validate :must_have_active_classroom, if: -> { role == 'estudiante' }

  has_many :lesson_completions, dependent: :destroy



  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
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


end
