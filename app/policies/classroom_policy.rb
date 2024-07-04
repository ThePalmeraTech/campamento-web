# app/policies/classroom_policy.rb
class ClassroomPolicy < ApplicationPolicy
  def show?
    # Permite acceso total a administradores
    user.admin? || record.students.include?(user)
  end
end
