# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  include ClassroomHelper
  skip_before_action :check_user_approved, only: [:new, :create, :cancel]
  before_action :set_classroom, only: [:create]

  def create
    super do |user|
      if user.persisted?
        if @classroom
          @classroom.classroom_students.create(user: user) # Asociar usuario al classroom
          flash[:notice] = "Registered successfully and added to the classroom!"
        else
          user.update(role: 'waiting') # O alguna lógica si no hay classroom disponible
          flash[:alert] = "No classroom available, placed on waiting list."
        end
      end
    end
  end

  private

  def set_classroom
    @classroom = Classroom.where(status: 'Abierto').find_by('students_count < ?', 9)
  end

  protected

  def after_sign_up_path_for(resource)
    waiting_approval_path  # Redirige a la ruta que informa al usuario que debe esperar la aprobación
  end

end
