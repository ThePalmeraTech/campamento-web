class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    # Aquí puedes poner cualquier lógica que necesites para cargar en la vista inicial
  end
end
