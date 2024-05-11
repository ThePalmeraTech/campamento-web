class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :profile, :update, :destroy]

  def index
    @users = User.all
    authorize @users
  end

  def show
    authorize @user
  end

  def profile
    # This action will render a user's profile
    # Assumes you have a profile.html.erb view for users
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
