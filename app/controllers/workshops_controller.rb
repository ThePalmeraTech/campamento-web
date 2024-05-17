class WorkshopsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_workshop, only: [:show, :edit, :update, :destroy]



  def index
    @workshops = Workshop.all
  end

  def show
    @workshop = Workshop.find(params[:id])
    @lessons = @workshop.lessons.order(:created_at)

    # Asegúrate de que current_user está disponible y se inicializa @completed_lessons como un arreglo vacío si no hay lecciones completadas
    if user_signed_in?
      @completed_lessons = LessonCompletion.where(user: current_user, lesson: @lessons).pluck(:lesson_id)
    else
      @completed_lessons = []
    end
  end

  def new
    @workshop = Workshop.new
  end

  def edit
    @workshop = Workshop.find(params[:id])
  end

  def create
    @workshop = Workshop.new(workshop_params)
    if @workshop.save
      redirect_to @workshop, status: :see_other, notice: 'Workshop was successfully created.'
    else
      logger.debug @workshop.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end



  def update
    if @workshop.update(workshop_params)
      redirect_to @workshop, notice: 'Workshop was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @workshop.destroy
    redirect_to workshops_url, notice: 'Workshop was successfully destroyed.'
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(:name, :description, :classroom_id, lessons_attributes: [:id, :title, :content, :_destroy])
  end

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Access denied."  # O cualquier otra ruta adecuada
    end
  end

end
