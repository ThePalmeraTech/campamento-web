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
    @students = User.where(role: 'estudiante')
    @waiting_users = User.where(approved: false).limit(per_page).offset(offset)# Agregar esta línea
    @total_waiting_pages = (User.where(role: 'waiting').count.to_f / per_page).ceil # Si necesitas paginación

    respond_to do |format|
      format.html
      format.js
    end

    # Códigos existentes para otros modelos
    @total_classroom_pages = (Classroom.count.to_f / per_page).ceil
    @classrooms = Classroom.where(status: 'Abierto').offset(page * per_page).limit(per_page)

    respond_to do |format|
      format.html
      format.js
    end
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
      return
    end
  end

end
