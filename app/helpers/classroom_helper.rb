module ClassroomHelper
  def available_student_slots
    classroom = Classroom.where(status: 'Abierto').first
    classroom ? 9 - classroom.students.count : 0
  end
end
