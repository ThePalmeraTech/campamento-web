class UserMailer < ApplicationMailer
    default from: 'campamentoweb@palmeratech.com'

  def welcome_email(user)
    @user = user
    @workshop = user.workshop
    @profile_link = edit_user_registration_url(@user)

    mail(to: @user.email, subject: "Bienvenid@ al #{@workshop.name}")
  end

  def reservation_email(user)
    @user = user
    @workshop = user.workshop

    mail(to: @user.email, subject: "Tu reserva para el taller #{@workshop.name}")
  end

  def new_user_notification(user)
    @user = user
    @workshop = user.workshop

    mail(
      to: 'palmeratech7@gmail.com',
      subject: "Nuevo usuario registrado: #{@user.full_name}"
    )
  end

  def approval_email(user)
    @user = user
    mail(to: @user.email, subject: 'Tu cuenta ha sido aprobada')
  end

  
end
