class UsersController < ApplicationController
  before_action :authenticate_user!, only:[:show, :edit, :profile, :update, :destroy]


  def index
    @users = User.all
    authorize @users
  end

  def profile
    @user = User.find(params[:id])  # Asegúrate de que esto esté obteniendo el usuario correcto.
    # Carga las lecciones completadas por el usuario
    @completed_lessons = LessonCompletion.includes(:lesson).where(user_id: @user.id).map(&:lesson)
  end


  def profile
    @user = User.find(params[:id])
    # Asegúrate de cargar las lecciones completadas por el usuario
    @completed_lessons = @user.lesson_completions.includes(:lesson).map(&:lesson)
  end


  def update
    authorize @user
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.turbo_stream
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end
