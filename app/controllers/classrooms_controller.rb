class ClassroomsController < ApplicationController
  before_action :set_classroom, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:new, :create, :update, :destroy]


    def new
    @classroom = Classroom.new
  end

  def index
    if current_user.admin?
      @classrooms = Classroom.all
      @classrooms = Classroom.order(created_at: :desc)
    else
      @classrooms = current_user.classrooms.order(created_at: :desc)
    end
  end

# app/controllers/classrooms_controller.rb
def show
  @classroom = Classroom.includes(:students, :workshop).find(params[:id])
  authorize @classroom  # Usa Pundit para autorizar

end


  def create
    @classroom = Classroom.new(classroom_params)
    if @classroom.save
      if @classroom.students.count >= 11
        @classroom.update(status: 'Completo')
      end
      redirect_to classrooms_path, notice: 'Classroom was successfully created.'
    else
      render :new
    end
  end


  def edit
    @classroom = Classroom.find_by(id: params[:id])
    if @classroom.nil? || @classroom.status != 'Abierto' || @classroom.students.count >= 11
      redirect_to classrooms_path, alert: 'Classroom cannot be edited due to its status or student count.'
    end
  end

  def update
    @classroom = Classroom.find(params[:id])
    if @classroom.update(classroom_params)
      if @classroom.students.count >= 11
        @classroom.update(status: 'En clase')
      end
      redirect_to admin_dashboard_path, notice: 'Classroom was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @classroom.destroy
    redirect_to classrooms_url, notice: 'Classroom was successfully destroyed.'
  end

  def index_for_user
    @classrooms = current_user.classrooms  # Asume que has configurado las asociaciones correctamente.
    render 'index'  # Reutiliza la vista index si es aplicable, o crea una nueva vista si es necesario.
  end

  private

  def set_classroom
    @classroom = Classroom.where(status: 'Abierto').find_by('students_count < ?', 11)
  end


  def check_admin
    redirect_to(root_url, alert: 'Only admin can perform this action.') unless current_user.admin?
  end

  def classroom_params
    params.require(:classroom).permit(:teacher_id, :day_count, :hours_per_class, :price_per_student, :status, :workshop_id, class_sessions_attributes: [:id, :session_date, :start_time, :end_time, :_destroy])
  end

  def set_workshop
    @workshop = Workshop.find_by(id: @classroom.workshop_id) if @classroom.workshop_id
  end

end
