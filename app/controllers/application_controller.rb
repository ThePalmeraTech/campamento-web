require 'pundit'

class ApplicationController < ActionController::Base
  # Asegurar que todos los usuarios estén autenticados para acceder a cualquier acción,
  # excepto las páginas públicas que puedes especificar en controladores individuales.
  before_action :authenticate_user!

  # Verifica si el usuario está aprobado para acceder a las funcionalidades internas,
  # excepto para los administradores que tienen acceso total.
  before_action :check_user_approved, if: :user_signed_in?

  # Configurar parámetros adicionales permitidos para Devise en caso de que sea necesario.
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Helper para calcular los slots disponibles en aulas abiertas.
  helper_method :available_student_slots

  # Integración de Pundit para manejo de políticas de autorización.
  include Pundit

  # Rescata de errores de autorización de Pundit y redirecciona adecuadamente.
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  # Método para configurar parámetros permitidos en Devise, especialmente útil durante el registro o actualización de usuarios.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :email, :phone, :age, :country, :city, :previous_experience, :previous_courses, :programming_skill_level, :motivation, :course_expectations, :specific_goals, :has_reliable_computer, :feedback_on_previous_courses, :full_payment_proof, :reservation_payment_proof])
  end

  private

  # Método para verificar si un usuario está aprobado para acceder a páginas internas.
  # Los administradores siempre están aprobados por defecto.
  def check_user_approved
    unless current_user.approved? || current_user.admin?
      redirect_to waiting_approval_path, alert: 'Su cuenta aún no ha sido aprobada por un administrador.'
    end
  end

  # Método para manejar acceso no autorizado con redirección y alerta adecuadas.
  def user_not_authorized
    redirect_to new_user_session_path, alert: 'No está autorizado para realizar esta acción.'
  end

  # Método para calcular cuántos estudiantes se pueden añadir a un aula con estado 'Abierto'.
  def available_student_slots
    classroom = Classroom.where(status: 'Abierto').first
    if classroom
      max_students = 11  # Asumiendo que el límite de estudiantes por aula es 11
      max_students - (classroom.students_count || 0)
    else
      0  # No hay aulas abiertas
    end
  end
end
