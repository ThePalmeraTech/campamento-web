class ClassSessionsController < ApplicationController
  before_action :set_class_session, only: [:show, :edit, :update, :destroy]

  # GET /class_sessions
  def index
    @class_sessions = ClassSession.all
  end

  # GET /class_sessions/new
  def new
    @class_session = ClassSession.new
  end

  # GET /class_sessions/1/edit
  def edit
  end

  # POST /class_sessions
  def create
    @class_session = ClassSession.new(class_session_params)

    if @class_session.save
      redirect_to class_sessions_path, notice: 'Class session was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /class_sessions/1
  def update
    if @class_session.update(class_session_params)
      redirect_to class_sessions_path, notice: 'Class session was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /class_sessions/1
  def destroy
    @class_session.destroy
    redirect_to class_sessions_url, notice: 'Class session was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_class_session
      @class_session = ClassSession.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def class_session_params
      params.require(:class_session).permit(:session_date, :start_time, :end_time)
    end
end
