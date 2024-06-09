class ClassSession < ApplicationRecord
  belongs_to :classroom

  def start_datetime
    DateTime.new(session_date.year, session_date.month, session_date.day, start_time.hour, start_time.min, 0) if session_date && start_time
  end
  
end
