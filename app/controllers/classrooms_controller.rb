class ClassroomsController < ApplicationController
  before_action :set_classroom, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:new, :create, :update, :destroy]


    def new
    @classroom = Classroom.new
  end

  def index
    @classrooms = Classroom.all
  end

  def show
    @classroom = Classroom.includes(:students).find(params[:id])
  end
  
  def create
    @classroom = Classroom.new(classroom_params)
    if @classroom.save
      if @classroom.students.count >= 9
        @classroom.update(status: 'Completo')
      end
      redirect_to classrooms_path, notice: 'Classroom was successfully created.'
    else
      render :new
    end
  end


  def edit
    @classroom = Classroom.find_by(id: params[:id])
    if @classroom.nil? || @classroom.status != 'Abierto' || @classroom.students.count >= 9
      redirect_to classrooms_path, alert: 'Classroom cannot be edited due to its status or student count.'
    end
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
    @classroom = Classroom.find(params[:id])
    # Actualiza el classroom con los nuevos parámetros
    if @classroom.update(classroom_params)
      # Verifica si se ha alcanzado el número máximo de estudiantes y cambia el estado
      if @classroom.students.count >= 9
        @classroom.update(status: 'En clase')
      end
      redirect_to admin_index_path, notice: 'Classroom was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
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
    params.require(:classroom).permit(:teacher_id, :day_count, :hours_per_class, :price_per_student, :status)
  end



end
