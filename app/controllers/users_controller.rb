class UsersController < ApplicationController
  before_action :authenticate_user!, only:[:show, :edit, :profile, :update, :destroy]


  def index
    @users = User.all
    authorize @users
  end

  def profile
    @user = User.find(params[:id])  # Asegúrate de que esto esté obteniendo el usuario correcto.
    # Carga las lecciones completadas por el usuario
    @completed_lessons = LessonCompletion.includes(:lesson).where(user_id: @user.id).map(&:lesson)
  end


  def profile
    @user = User.find(params[:id])
    # Asegúrate de cargar las lecciones completadas por el usuario
    @completed_lessons = @user.lesson_completions.includes(:lesson).map(&:lesson)
  end


  def update
    authorize @user
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    redirect_to(root_path, alert: "User not found.") and return unless @user
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.turbo_stream
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end

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
