class CreateWorkshops < ActiveRecord::Migration[7.0]
  def change
    create_table :workshops do |t|
      t.string :name
      t.text :description
      t.references :classroom, null: false, foreign_key: true

      t.timestamps
    end
  end
end
