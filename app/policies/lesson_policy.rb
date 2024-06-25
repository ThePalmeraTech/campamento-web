# app/policies/lesson_policy.rb
class LessonPolicy < ApplicationPolicy
  def show?
    # Permite acceso total a administradores
    return true if user.admin?

    # Los usuarios regulares solo pueden ver lecciones de los talleres de sus aulas
    user.classrooms.includes(:workshop).any? { |classroom| classroom.workshop.lessons.include?(record) }
  end

  # Asegúrate de definir políticas similares para otras acciones si es necesario
  def update?
    show?
  end

  def edit?
    show?
  end

  def destroy?
    show?
  end

  def toggle_completion?
    return true if user.admin?

    # Assuming `workshop` is connected to `classrooms` which are in turn connected to `students` (users)
    record.workshop.classrooms.any? do |classroom|
      classroom.students.include?(user)
    end
  end
end
