class AddStudentsCountToClassrooms < ActiveRecord::Migration[7.0]
  def change
    add_column :classrooms, :students_count, :integer, default: 0

    Classroom.reset_column_information
    Classroom.find_each do |classroom|
      Classroom.reset_counters(classroom.id, :students)
    end
  end
end
