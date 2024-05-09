class SessionsController < Devise::SessionsController
  # Añade cualquier lógica personalizada aquí
  skip_before_action :check_user_approved, only: [:new, :create]
end
