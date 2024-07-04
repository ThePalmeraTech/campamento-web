module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin
    before_action :set_user, only: [:approve, :destroy]

    def approve
      @user = User.find(params[:id])
      @user.skip_password_validation = true

      if can_be_approved?(@user)
        ActiveRecord::Base.transaction do
          @user.update!(approved: true)
          unless assign_to_classroom(@user)
            redirect_to admin_dashboard_path, alert: 'Aprobado, pero no hay aulas disponibles que coincidan con la selección del taller.'
            return
          end
        end
        redirect_to admin_dashboard_path, notice: 'Usuario aprobado y asignado al aula con éxito.'
      else
        redirect_to admin_dashboard_path, alert: 'No hay aulas disponibles. El usuario no puede ser aprobado en este momento.'
      end
    end

    private

    def can_be_approved?(user)
      workshop = user.workshop
      workshop && workshop.classrooms.any? { |classroom| classroom.status == 'Abierto' }
    end

    def assign_to_classroom(user)
      classroom = user.workshop.classrooms.find_by(status: 'Abierto')
      if classroom
        ClassroomStudent.create!(classroom: classroom, user: user)
        Rails.logger.info "User #{user.email} assigned to Classroom #{classroom.id}"
        true
      else
        Rails.logger.info "No open classroom available for Workshop #{user.workshop.id}"
        false
      end
    end

    def set_user
      @user = User.find(params[:id])
    end

    def ensure_admin
      redirect_to root_path, alert: 'Acceso denegado. Solo los administradores pueden realizar esta acción.' unless current_user.admin?
    end
  end
end
