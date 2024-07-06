class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  skip_before_action :verify_authenticity_token, only: [:index], if: :js_request?
  before_action :check_user_approved, except: :approve

  def index
    page = params[:page].to_i
    per_page = 10
    offset = page * per_page

    @coders = User.where(role: 'Coder').limit(per_page).offset(offset)
    @total_pages = (User.where(role: 'Coder').count.to_f / per_page).ceil
    # Filtra para obtener solo los estudiantes que han sido aprobados
    @students = User.where(role: 'estudiante', approved: true)

    @waiting_users = User.where(approved: false)
    @total_waiting_pages = (User.where(approved: false).count.to_f / per_page).ceil

    @total_classroom_pages = (Classroom.count.to_f / per_page).ceil
    @classrooms = Classroom.where(status: 'Abierto').offset(page * per_page).limit(per_page)

    respond_to do |format|
      format.html
      format.js
    end
  end

# app/controllers/admin/dashboard_controller.rb
def income_report
  authorize :dashboard, :admin_access?

  @total_income = Classroom.all.sum(&:total_cost)
  workshops = Workshop.includes(:classrooms).all

  @workshops = workshops.map do |workshop|
    {
      name: workshop.name,
      income: workshop.classrooms.sum(&:total_cost)
    } if workshop.classrooms.any?
  end.compact  # Ensure no nil entries and @workshops is always an array
end


  private

  def ensure_admin
    redirect_to root_path, alert: 'Access denied' unless current_user&.admin?
  end

  def js_request?
    request.format.js?
  end

  def check_user_approved
    unless current_user.approved? || current_user.admin?
      redirect_to waiting_approval_path, alert: "You must be approved to access this page."
    end
  end
end
