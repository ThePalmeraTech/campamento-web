class AddWorkshopIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :workshop_id, :integer
  end
end
