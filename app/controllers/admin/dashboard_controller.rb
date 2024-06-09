class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  skip_before_action :verify_authenticity_token, only: [:index], if: :js_request?

  def index
    page = params[:page].to_i
    per_page = 10
    offset = page * per_page

    @coders = User.where(role: 'Coder').limit(per_page).offset(offset)
    @total_pages = (User.where(role: 'Coder').count.to_f / per_page).ceil
    @students = User.where(role: 'estudiante')

    respond_to do |format|
      format.html
      format.js
    end

     # Códigos existentes para otros modelos
  page = params[:page].to_i
  per_page = 10
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
end
