# app/controllers/lessons_controller.rb
class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  before_action :set_workshop, only: [:new, :create, :index]

  def index
    @lessons = @workshop.lessons
  end

  def new
    @workshop = Workshop.find(params[:workshop_id])
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
    if params[:workshop_id]
      set_workshop
      @lessons = @workshop.lessons
    else
      @lessons = Lesson.all  # O puedes elegir redirigir al usuario o manejar este caso de alguna manera
    end
  end

  def show
    @workshop = Workshop.find(params[:workshop_id])
    @lesson = Lesson.find(params[:id])
  end

# app/controllers/lessons_controller.rb
def edit
  @workshop = Workshop.find(params[:workshop_id])
  @lesson = Lesson.find(params[:id])
end

  def update
    if @lesson.update(lesson_params)
      redirect_to @lesson, notice: 'Lesson was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @lesson.destroy
    redirect_to lessons_url, notice: 'Lesson was successfully destroyed.'
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
