# app/controllers/lessons_controller.rb
class LessonsController < ApplicationController
  before_action :set_workshop
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  def new
    @lesson = @workshop.lessons.new
  end

  def create
    @lesson = @workshop.lessons.build(lesson_params)
    if @lesson.save
      redirect_to [@workshop, @lesson], notice: 'Lesson was successfully created.'
    else
      render :new
    end
  end

  def index
    @lessons = @workshop.lessons
  end

  def show
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

  private

  def set_workshop
    @workshop = Workshop.find(params[:workshop_id])
  end

  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :content)
  end
end
