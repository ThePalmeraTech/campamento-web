class RemoveAssistantIdFromClassrooms < ActiveRecord::Migration[7.0]
  def change
    # Elimina la clave foránea si existe, asegurándote de especificar la tabla y la columna correctas
    remove_foreign_key :classrooms, column: :assistant_id if foreign_key_exists?(:classrooms, column: :assistant_id)

    # Elimina la columna
    remove_column :classrooms, :assistant_id
  end
end
