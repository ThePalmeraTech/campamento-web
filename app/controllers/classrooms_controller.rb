class ClassroomsController < ApplicationController
  before_action :set_classroom, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:new, :create, :update, :destroy]

  def new
    @classroom = Classroom.new
    @classroom.class_sessions.build  # Construye una sesión de clase inicial para el formulario
    Rails.logger.debug "Initialized new classroom with one session: #{@classroom.inspect}"
  end

  def index
    if current_user.admin?
      @classrooms = Classroom.order(created_at: :desc)
      Rails.logger.debug "Admin user loaded all classrooms"
    else
      @classrooms = current_user.classrooms.order(created_at: :desc)
      Rails.logger.debug "Non-admin user loaded their classrooms"
    end
  end

  def show
    @classroom_students = @classroom.classroom_students
    authorize @classroom  # Usa Pundit para autorizar
    Rails.logger.debug "Showing classroom: #{@classroom.inspect}"
  end

  def create
    @classroom = Classroom.new(classroom_params)
    @classroom.price_per_student = calculate_price_per_student(@classroom)
    Rails.logger.debug "Attempting to create classroom: #{@classroom.inspect}"

    if @classroom.save
      check_students_count(@classroom)
      Rails.logger.debug "Classroom created successfully: #{@classroom.inspect}"
      redirect_to classrooms_path, notice: 'Classroom was successfully created.'
    else
      Rails.logger.error "Failed to create classroom: #{@classroom.errors.full_messages.to_sentence}"
      flash[:error] = @classroom.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    Rails.logger.debug "Editing classroom: #{@classroom.inspect}"
  end

  def update
    if @classroom.update(classroom_params)
      @classroom.price_per_student = calculate_price_per_student(@classroom)
      if @classroom.save
        check_students_count(@classroom)
        Rails.logger.debug "Classroom updated successfully: #{@classroom.inspect}"
        redirect_to admin_dashboard_path, notice: 'Classroom was successfully updated.'
      else
        Rails.logger.error "Failed to save updated classroom: #{@classroom.errors.full_messages.to_sentence}"
        flash[:error] = @classroom.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      Rails.logger.error "Failed to update classroom: #{@classroom.errors.full_messages.to_sentence}"
      flash[:error] = @classroom.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @classroom.destroy
    Rails.logger.debug "Classroom destroyed: #{@classroom.inspect}"
    redirect_to classrooms_url, notice: 'Classroom was successfully destroyed.'
  end

  private

  def set_classroom
    @classroom = Classroom.find(params[:id])
    Rails.logger.debug "Set classroom: #{@classroom.inspect}"
  end

  def check_admin
    unless current_user.admin?
      Rails.logger.warn "Unauthorized access attempt by user: #{current_user.inspect}"
      redirect_to(root_url, alert: 'Only admin can perform this action.')
    end
  end

  def classroom_params
    params.require(:classroom).permit(:teacher_id, :day_count, :hours_per_class, :price_per_student, :regular_price, :discount_percentage, :status, :workshop_id, class_sessions_attributes: [:id, :session_date, :start_time, :end_time, :_destroy])
  end

  def check_students_count(classroom)
    if classroom.students_count >= 11
      classroom.update(status: 'Completo')
      Rails.logger.debug "Classroom marked as 'Completo' due to students count: #{classroom.inspect}"
    end
  end

  def calculate_price_per_student(classroom)
    regular_price = classroom.regular_price.to_f
    discount_percentage = classroom.discount_percentage.to_f
    discounted_price = regular_price - (regular_price * discount_percentage / 100)
    students_count = classroom.students_count || 1
    price_per_student = (discounted_price / students_count).round(2)
    Rails.logger.debug "Calculated price per student: #{price_per_student} for classroom: #{classroom.inspect}"
    price_per_student
  end
end
