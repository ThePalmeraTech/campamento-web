require 'pundit'

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_user_approved, if: :user_signed_in?
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :available_student_slots

  def available_student_slots
    classroom = Classroom.where(status: 'Abierto').first
    if classroom
      max_students = 11  # Asumiendo que el límite de estudiantes por classroom es 9
      max_students - (classroom.students_count || 0)
    else
      0  # No hay classrooms abiertos
    end
  end

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :email, :phone, :age, :country, :city, :previous_experience, :previous_courses, :programming_skill_level, :motivation, :course_expectations, :specific_goals, :has_reliable_computer, :feedback_on_previous_courses, :full_payment_proof, :reservation_payment_proof])
  end

private

def check_user_approved
  unless current_user.approved?
    redirect_to waiting_approval_path, alert: 'Su cuenta aún no ha sido aprobada por un administrador.'
  end
end


def user_not_authorized
  redirect_to new_user_session_path, alert: 'No está autorizado para realizar esta acción.'
end

end
