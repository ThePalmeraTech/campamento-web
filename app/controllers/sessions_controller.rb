class SessionsController < Devise::SessionsController
  skip_before_action :check_user_approved, only: [:new, :create]

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      super  # Esto hace que el comportamiento sea el predeterminado de Devise para usuarios no admin.
    end
  end
end
