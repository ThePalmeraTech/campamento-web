class AddWorkshopIdToClassrooms < ActiveRecord::Migration[7.0]
  def change
    add_column :classrooms, :workshop_id, :integer
    add_index :classrooms, :workshop_id  # Opcional: Añade un índice para mejorar el rendimiento de las consultas.
  end
end
