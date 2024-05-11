module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin
    before_action :set_user, only: [:approve, :destroy]

    def approve
      user = User.find(params[:id])
      user.update(approved: true)
      redirect_to admin_dashboard_path, notice: 'User approved successfully'
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      redirect_to admin_dashboard_path, notice: 'User deleted successfully'
    end

    private

    def ensure_admin
      unless current_user.admin?
        redirect_to root_path, alert: "Access denied. Only admins can perform this action."
      end
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
