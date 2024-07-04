# app/policies/workshop_policy.rb
class WorkshopPolicy < ApplicationPolicy
  def show?
    # Los administradores pueden ver todos los talleres
    return true if user.admin?

    # Los usuarios regulares solo pueden ver talleres asociados a sus aulas
    user.classrooms.joins(:workshop).exists?(workshops: { id: record.id })
  end

  def per_student_price?
    true  # Esto permite el acceso público
  end
  
end
