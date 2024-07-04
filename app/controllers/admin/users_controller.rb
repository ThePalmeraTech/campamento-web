module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin
    before_action :set_user, only: [:approve, :destroy]

    def approve
      @user = User.find(params[:id])

      if can_be_approved?(@user)
        ActiveRecord::Base.transaction do
          @user.update!(approved: true)
          unless assign_to_classroom(@user)
            redirect_to admin_dashboard_path, alert: 'Approved, but no available classrooms matched the workshop selection.'
            return
          end
        end
        redirect_to admin_dashboard_path, notice: 'User approved and assigned to classroom successfully.'
      else
        redirect_to admin_dashboard_path, alert: 'No available classrooms. User cannot be approved at this time.'
      end
    end

    private

    def can_be_approved?(user)
      # Assume user is linked to a workshop
      workshop = user.workshop
      workshop && workshop.classrooms.any? { |classroom| classroom.status == 'Abierto' }
    end

    def assign_to_classroom(user)
      # Find the first open classroom for the user's selected workshop
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
      redirect_to root_path, alert: 'Access denied. Only admins can perform this action.' unless current_user.admin?
    end
  end
end
