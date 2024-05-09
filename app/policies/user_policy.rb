class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.admin? || user.coder?
  end

  def show?
    user.admin? || user.coder? || record.id == user.id
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  # Aquí puedes agregar más métodos según las acciones que necesites controlar

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
