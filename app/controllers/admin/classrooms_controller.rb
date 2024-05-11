module Admin
  class ClassroomsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin
    before_action :set_classroom, only: [:show, :edit, :update, :destroy]
    before_action :check_admin, only: [:new, :create, :update, :destroy]

    def show
      # código para mostrar un aula específica
    end

    def edit
      # No es necesario agregar nada aquí si set_classroom ya inicializa @classroom
    end

    def update
      @classroom = Classroom.find(params[:id])
      if @classroom.update(classroom_params)
        @classroom.update(status: 'En clase') if @classroom.students.count >= 9
        redirect_to admin_dashboard_path, notice: 'Classroom was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @classroom.destroy
      redirect_to admin_dashboard_path, notice: 'Classroom was successfully destroyed.'
    end

    private

    def set_classroom
      @classroom = Classroom.find_by(id: params[:id])
      redirect_to classrooms_path, alert: 'Classroom not found' unless @classroom
    end

    def classroom_params
      params.require(:classroom).permit(:teacher_id, :day_count, :hours_per_class, :price_per_student, :status, class_sessions_attributes: [:id, :session_date, :start_time, :end_time, :_destroy])
    end

    def ensure_admin
      redirect_to root_path, alert: 'Access denied. Only admins can perform this action.' unless current_user.admin?
    end

    def check_admin
      redirect_to root_path, alert: 'Only admin can perform this action.' unless current_user.admin?
    end
  end
end
