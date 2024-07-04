class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create, :new]

  def new
    super
    @workshops = Workshop.all
    if params[:user] && params[:user][:workshop_id].present?
      workshop_id = params[:user][:workshop_id]
      logger.info "Workshop ID received: #{workshop_id}"
      classroom = Classroom.where(workshop_id: workshop_id).order(created_at: :desc).first
      if classroom
        @price_per_student = classroom.price_per_student
        logger.info "Price per student set to #{@price_per_student}"
      else
        logger.info "No classroom found for workshop_id #{workshop_id}"
      end
    else
      logger.info "No workshop_id found in params"
    end
  end

  def create
    super do |user|
      user.role = 'estudiante' unless user.admin?
      user.approved = false unless user.admin?
      user.save!
    end
  end

  protected

  def after_sign_up_path_for(resource)
    resource.admin? ? admin_dashboard_path : waiting_approval_path
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :full_name, :email, :password, :password_confirmation, :phone,
      :workshop_id, :payment_option, :full_payment_proof, :reservation_payment_proof,
      :age, :country, :city, :previous_experience, :previous_courses,
      :programming_skill_level, :motivation, :course_expectations,
      :specific_goals, :has_reliable_computer, :feedback_on_previous_courses
    ])
  end

  private

  def sign_up_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :phone, :workshop_id, :payment_option, :payment_method, :payment_proof, :reservation_payment_proof, :full_payment_proof)
  end

  def account_update_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :current_password, :phone, :workshop_id, :payment_option, :payment_method, :payment_proof, :reservation_payment_proof, :full_payment_proof)
  end

end
