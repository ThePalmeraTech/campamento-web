class CreateLessonCompletions < ActiveRecord::Migration[7.0]
  def change
    create_table :lesson_completions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.string :status, null: false
      t.datetime :completion_date

      t.timestamps
    end
    add_index :lesson_completions, [:user_id, :lesson_id], unique: true
  end
end
