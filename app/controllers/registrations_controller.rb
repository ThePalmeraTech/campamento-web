class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create, :new]
  skip_before_action :authenticate_user!, only: [:check_email]
  skip_before_action :verify_authenticity_token, only: [:check_email]

  def new
    @user = User.new
    @workshops = Workshop.all
    if params[:user] && params[:user][:workshop_id].present?
      workshop_id = params[:user][:workshop_id]
      classroom = Classroom.where(workshop_id: workshop_id).order(created_at: :desc).first
      if classroom
        @price_per_student = classroom.price_per_student
        @regular_price = classroom.regular_price
        @discount_percentage = classroom.discount_percentage
        logger.info "Precio por estudiante configurado en #{@price_per_student}"
        logger.info "Precio regular configurado en #{@regular_price}"
        logger.info "Porcentaje de descuento cargado: #{@discount_percentage}%"
      else
        logger.info "No se encontró un salón para el ID de taller #{workshop_id}"
      end
    else
      logger.info "No se encontró el ID del taller en los parámetros"
    end
    super
  end

  def create
    build_resource(sign_up_params)

    if resource.payment_option == "reservation"
      resource.payment_status = "reservation"
    else
      resource.payment_status = "complete"
    end

    if resource.save
      yield resource if block_given?
      if resource.persisted?
        send_welcome_email(resource)
        send_admin_notification(resource)
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      if User.exists?(email: resource.email)
        flash.now[:alert] = "El correo electrónico ya está en uso. Por favor, intente con otro."
      end
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def check_email
    email = params[:email]
    is_unique = !User.exists?(email: email)
    render json: { unique: is_unique }
  end

  protected

  def after_sign_up_path_for(resource)
    resource.admin? ? admin_dashboard_path : waiting_approval_path
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :full_name, :email, :password, :password_confirmation, :phone,
      :workshop_id, :payment_option, :payment_method, :full_payment_proof, :reservation_payment_proof,
      :age, :country, :city, :previous_experience, :previous_courses,
      :programming_skill_level, :motivation, :course_expectations,
      :specific_goals, :has_reliable_computer, :feedback_on_previous_courses
    ])
  end

  private

  def sign_up_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :phone, :workshop_id, :payment_option, :payment_method, :full_payment_proof, :reservation_payment_proof)
  end

  def account_update_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :current_password, :phone, :workshop_id, :payment_option, :payment_method, :full_payment_proof, :reservation_payment_proof)
  end

  def send_welcome_email(user)
    if user.payment_status == "complete"
      UserMailer.welcome_email(user).deliver_now
    else
      UserMailer.reservation_email(user).deliver_now
    end
  end

  def send_admin_notification(user)
    UserMailer.new_user_notification(user).deliver_now
  end
end
