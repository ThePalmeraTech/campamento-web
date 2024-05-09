class ClassroomsController < ApplicationController
  before_action :set_classroom, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:new, :create, :update, :destroy]

  def index
    @classrooms = Classroom.all
  end

  def show
  end

  def new
    @classroom = Classroom.new
    # Asegúrate de que esto se corresponda con la lógica de tu formulario
    3.times { @classroom.class_sessions.build }
  end



  def edit
  end

  def create
    @classroom = Classroom.new(classroom_params)
    if @classroom.save
      redirect_to classrooms_path, notice: 'Classroom was successfully created.'
    else
      render :new
    end
  end



  def update
    if @classroom.update(classroom_params)
      redirect_to @classroom, notice: 'Classroom was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @classroom.destroy
    redirect_to classrooms_url, notice: 'Classroom was successfully destroyed.'
  end




  private

  def set_classroom
    @classroom = Classroom.where(status: 'Abierto').find_by('students_count < ?', 9)
  end


  def check_admin
    redirect_to(root_url, alert: 'Only admin can perform this action.') unless current_user.admin?
  end

  def classroom_params
    params.require(:classroom).permit(:teacher_id, :day_count, :hours_per_class, :price_per_student, :status, class_sessions_attributes: [:id, :session_date, :start_time, :end_time, :_destroy])
  end


end
