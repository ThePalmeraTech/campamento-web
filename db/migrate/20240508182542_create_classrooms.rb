class CreateClassrooms < ActiveRecord::Migration[7.0]
  def change
    create_table :classrooms do |t|
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.integer :day_count
      t.integer :hours_per_class
      t.decimal :price_per_student, precision: 8, scale: 2
      t.string :status

      t.timestamps
    end
  end
end
