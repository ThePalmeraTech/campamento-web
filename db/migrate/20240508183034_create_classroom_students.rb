class CreateClassroomStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :classroom_students do |t|
      t.references :classroom, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
