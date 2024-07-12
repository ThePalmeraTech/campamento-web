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

  def income_report
    @total_income = Classroom.all.sum(&:total_cost)

    @income_by_workshop = Workshop.includes(:classrooms).map do |workshop|
      {
        workshop: workshop,
        income: workshop.classrooms.sum(&:total_cost)
      }
    end

    @income_by_classroom = Classroom.all.map do |classroom|
      {
        classroom: classroom,
        income: classroom.total_cost
      }
    end

    classrooms = Classroom.all
    @income_over_time = classrooms.group_by { |c| c.created_at.beginning_of_month }
                                  .transform_values { |classrooms| classrooms.sum(&:total_cost) }

    # Debugging
    Rails.logger.info "Income by Workshop: #{@income_by_workshop.inspect}"
    Rails.logger.info "Income by Classroom: #{@income_by_classroom.inspect}"
    Rails.logger.info "Income Over Time: #{@income_over_time.inspect}"
  end

  private

  def ensure_admin
    redirect_to root_path, alert: 'Acceso denegado' unless current_user&.admin?
  end

  def js_request?
    request.format.js?
  end

  def check_user_approved
    unless current_user.approved? || current_user.admin?
      redirect_to waiting_approval_path, alert: "Debes ser aprobado por el admin antes de acceder a esta página."
    end
  end
end
