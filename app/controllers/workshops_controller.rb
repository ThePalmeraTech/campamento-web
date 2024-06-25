class WorkshopsController < ApplicationController
  before_action :authenticate_user!, except: [:per_student_price]
  skip_before_action :authenticate_user!, only: [:per_student_price]

  before_action :check_admin, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_workshop, only: [:show, :edit, :update, :destroy, :per_student_price]



  def index
    @workshops = Workshop.all
  end

  def show
    @workshop = Workshop.find(params[:id])
    authorize @workshop

    # Correctly setting @lessons after ensuring the workshop can be shown.
    @lessons = @workshop.lessons.order(:created_at)

    # Initialize @completed_lessons based on current_user
    if user_signed_in?
      @completed_lessons = LessonCompletion.where(user: current_user, lesson: @lessons).pluck(:lesson_id)
    else
      @completed_lessons = []
    end

  rescue Pundit::NotAuthorizedError
    # Redirect if the user is not authorized to view this workshop
    redirect_to root_path, alert: "You are not authorized to view this workshop."
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

  def per_student_price
    # Asumiendo que los workshops tienen asociados uno o más classrooms
    classroom = @workshop.classrooms.order(created_at: :desc).first
    if classroom
      render json: { price: classroom.price_per_student }
    else
      render json: { error: "No classroom available for this workshop." }, status: :not_found
    end
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
