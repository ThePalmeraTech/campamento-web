class ChangeClassroomIdToBeNullableInWorkshops < ActiveRecord::Migration[7.0]
  def change
    change_column_null :workshops, :classroom_id, true
  end
end
