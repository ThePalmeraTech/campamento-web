class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:el_coding_challenge]

  def el_coding_challenge
    # Lógica para la página de landing
  end
end
