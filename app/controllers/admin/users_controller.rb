module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin
    before_action :set_user, only: [:approve, :destroy]

    def approve
      user = User.find(params[:id])
      if user.update(approved: true)  # Asumiendo que el campo se llama 'approved'
        flash[:notice] = 'User approved successfully.'
      else
        flash[:alert] = 'Failed to approve user.'
      end
      redirect_to admin_dashboard_path  # Asegúrate de redirigir a la vista correcta
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      redirect_to admin_dashboard_path, notice: 'User deleted successfully'
    end

    private

    def ensure_admin
      redirect_to root_path, alert: 'Access denied. Only admins can perform this action.' unless current_user.admin?
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
