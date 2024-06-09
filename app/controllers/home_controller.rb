# app/controllers/home_controller.rb
class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @classrooms = current_user.classrooms.includes(:workshop, :students)
  end
end
