class ClassroomStudent < ApplicationRecord
  belongs_to :classroom, counter_cache: :students_count
  belongs_to :user
end
