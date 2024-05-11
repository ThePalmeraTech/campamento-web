class AddFinalStudentCountToClassrooms < ActiveRecord::Migration[7.0]
  def change
    add_column :classrooms, :final_student_count, :integer
  end
end
