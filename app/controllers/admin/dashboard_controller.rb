class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @students = User.where(role: 'estudiante')  # Filtra para obtener solo estudiantes
    @coders = User.where(role: 'Coder')  # Filtra para obtener solo coders
    @classrooms = Classroom.all
  end


  private

  def ensure_admin
    redirect_to root_path, alert: 'Access denied' unless current_user&.admin?
  end
end
