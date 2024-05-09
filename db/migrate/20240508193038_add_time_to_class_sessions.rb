class AddTimeToClassSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :class_sessions, :start_time, :time
    add_column :class_sessions, :end_time, :time
  end
end
