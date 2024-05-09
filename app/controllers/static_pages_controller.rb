class StaticPagesController < ApplicationController
  skip_before_action :check_user_approved, only: [:waiting_approval]
  
  def waiting_approval
    # Vista simple que informa al usuario que su cuenta está en espera de aprobación.
  end
end
