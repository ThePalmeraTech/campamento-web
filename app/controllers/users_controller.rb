class UsersController < ApplicationController
  before_action :authenticate_user!, only:[:show, :edit, :profile, :update, :destroy]
  before_action :set_user, only: [:update, :show, :destroy]

  def index
    @users = User.all
    authorize @users
  end

  def profile
    @user = User.find(params[:id])
    @completed_lessons = LessonCompletion.includes(:lesson).where(user_id: @user.id).map(&:lesson)
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def show
    redirect_to(root_path, alert: "User not found.") and return unless @user
  end

  def destroy
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
