# app/policies/dashboard_policy.rb
class DashboardPolicy < ApplicationPolicy
  def admin_access?
    user.admin?
  end
end
