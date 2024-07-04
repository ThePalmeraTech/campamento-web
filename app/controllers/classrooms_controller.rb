class ClassroomsController < ApplicationController
  before_action :set_classroom, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:new, :create, :update, :destroy]

  def new
    @classroom = Classroom.new
  end

  def index
    if current_user.admin?
      @classrooms = Classroom.order(created_at: :desc)
    else
      @classrooms = current_user.classrooms.order(created_at: :desc)
    end
  end

  def show
    @classroom_students = @classroom.classroom_students
    authorize @classroom  # Usa Pundit para autorizar
  end

  def create
    @classroom = Classroom.new(classroom_params)
    if @classroom.save
      check_students_count(@classroom)
      redirect_to classrooms_path, notice: 'Classroom was successfully created.'
    else
      render :new
    end
  end

  def edit
    # No se necesitan condiciones restrictivas aquí
  end

  def update
    if @classroom.update(classroom_params)
      check_students_count(@classroom) # Asegúrate de que esta función no impide la actualización sin manejo adecuado de errores.
      redirect_to admin_dashboard_path, notice: 'Classroom was successfully updated.'
    else
      # Log the errors to help with debugging
      Rails.logger.info @classroom.errors.full_messages.to_sentence
      flash[:error] = @classroom.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @classroom.destroy
    redirect_to classrooms_url, notice: 'Classroom was successfully destroyed.'
  end

  private

  def set_classroom
    @classroom = Classroom.find(params[:id])
  end

  def check_admin
    redirect_to(root_url, alert: 'Only admin can perform this action.') unless current_user.admin?
  end

  def classroom_params
    params.require(:classroom).permit(:teacher_id, :day_count, :hours_per_class, :price_per_student, :regular_price, :discount_percentage, :status, :workshop_id, class_sessions_attributes: [:id, :session_date, :start_time, :end_time, :_destroy])
  end

  def check_students_count(classroom)
    if classroom.students_count >= 11
      classroom.update(status: 'Completo')
    end
  end
end
