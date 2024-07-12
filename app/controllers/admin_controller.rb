class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @classrooms = Classroom.all
    @users = User.where(role: 'estudiante')  # Ensure only users with the role of 'student' are listed
  end


  def approve
    user = User.find(params[:id])
    user.update(approved: true)
    redirect_to admin_path, notice: 'Usuario aprobado'
  end

  private

  def ensure_admin
    redirect_to root_path, alert: 'Acceso denegado' unless current_user.admin?
  end
end
