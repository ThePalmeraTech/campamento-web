# app/controllers/lessons_controller.rb
class LessonsController < ApplicationController
  before_action :set_workshop
before_action :set_lesson, only: [:show, :edit, :update, :destroy, :toggle_completion]
before_action :authorize_lesson, only: [:new, :create, :edit, :update, :destroy]


  def new
    @lesson = @workshop.lessons.new
    authorize @lesson
  end

  def create
    @lesson = @workshop.lessons.build(lesson_params)
    authorize @lesson
    if @lesson.save
      redirect_to [@workshop, @lesson], notice: 'Lesson was successfully created.'
    else
      render :new
    end
  end

  def index
    @lessons = @workshop.lessons
    @lessons = @workshop.lessons.includes(:completions)
  @completed_lessons = LessonCompletion.where(user: current_user, lesson: @lessons).pluck(:lesson_id)
  end

  def show
    @lesson = Lesson.find(params[:id])
  end


  def edit
  end

  def update
    if @lesson.update(lesson_params)
      redirect_to workshop_lesson_path(@workshop, @lesson), notice: 'Lesson was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @lesson.destroy
    redirect_to workshop_lessons_path(@workshop), notice: 'Lesson was successfully destroyed.'
  end

  def toggle_completion
    completion = @lesson.completions.find_by(user: current_user)

    if completion
      completion.destroy
      flash[:notice] = 'Lección marcada como no completada.'
    else
      LessonCompletion.create!(lesson: @lesson, user: current_user, status: 'completada')
      flash[:notice] = 'Lección marcada como completada.'
    end

    redirect_to workshop_lesson_path(@lesson.workshop, @lesson)
  end


  def next_lesson
    workshop.lessons.where('id > ?', id).order(:id).first
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
    authorize @lesson || Lesson.new
  end


  def lesson_params
    params.require(:lesson).permit(:title, :content)
  end
end