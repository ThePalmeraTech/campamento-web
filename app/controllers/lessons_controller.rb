# app/controllers/lessons_controller.rb
class LessonsController < ApplicationController
  before_action :set_workshop
  before_action :set_lesson, only: [:show, :edit, :update, :destroy, :toggle_completion]
  before_action :authorize_lesson, except: [:index, :new, :create]

  def new
    @lesson = @workshop.lessons.new
    authorize @lesson
  end

  def create
    @lesson = @workshop.lessons.build(lesson_params)
    authorize @lesson
    if @lesson.save
      redirect_to [@workshop, @lesson], notice: 'La lección se creó exitosamente.'
    else
      render :new
    end
  end

  def index
    authorize @workshop, :show?
    @lessons = @workshop.lessons.includes(:completions)
    @completed_lessons = LessonCompletion.where(user: current_user, lesson: @lessons).pluck(:lesson_id)
  end

  def show
    @lesson = Lesson.find(params[:id])
    @workshop = @lesson.workshop  # Asignación correcta
    authorize @workshop  # Verifica permisos para ver el taller asociado

    # La siguiente línea podría eliminarse si solo necesitas mostrar detalles de la lección específica
    @lessons = @workshop.lessons.presence || []  # Innecesario si solo se muestra una lección
  end

  def edit
  end

  def update
    if @lesson.update(lesson_params)
      redirect_to workshop_lesson_path(@workshop, @lesson), notice: 'La lección se actualizó exitosamente.'
    else
      render :edit
    end
  end

  def destroy
    @lesson.destroy
    redirect_to workshop_lessons_path(@workshop), notice: 'La lección se eliminó exitosamente.'
  end

  def toggle_completion
    completion = @lesson.completions.find_by(user: current_user)

    if completion
      completion.destroy
      flash[:notice] = 'Lección marcada como no completada.'
      redirect_to workshop_lesson_path(@lesson.workshop, @lesson)
    else
      LessonCompletion.create!(lesson: @lesson, user: current_user, status: 'completada')
      flash[:notice] = 'Lección marcada como completada.'
      next_lesson = @lesson.next_lesson
      if next_lesson
        redirect_to workshop_lesson_path(@lesson.workshop, next_lesson)
      else
        flash[:notice] = '¡Felicidades! Has completado el taller.'
        redirect_to workshop_lessons_path(@lesson.workshop)
      end
    end
  end

  def next_lesson
    workshop.lessons.where("id > ?", self.id).order(:id).first
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:workshop_id])
  end

  def set_lesson
    @lesson = @workshop.lessons.find_by(id: params[:id])
    if @lesson.nil?
      flash[:alert] = "Lección no encontrada."
      redirect_to workshop_lessons_path(@workshop)
    end
  end

  def authorize_lesson
    authorize @lesson
  end

  def lesson_params
    params.require(:lesson).permit(:title, :content)
  end
end
