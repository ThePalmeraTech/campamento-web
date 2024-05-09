class CreateClassSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :class_sessions do |t|
      t.references :classroom, null: false, foreign_key: true
      t.date :session_date
      t.integer :duration

      t.timestamps
    end
  end
end
