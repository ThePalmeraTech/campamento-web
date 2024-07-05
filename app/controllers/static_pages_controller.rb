class StaticPagesController < ApplicationController
  skip_before_action :check_user_approved, only: [:waiting_approval]
  before_action :authenticate_user!

  def waiting_approval
    @user = current_user
  end
end
