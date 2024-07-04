class AddPricingToClassrooms < ActiveRecord::Migration[7.0]
  def change
    add_column :classrooms, :regular_price, :decimal, precision: 8, scale: 2
    add_column :classrooms, :discount_percentage, :decimal, precision: 5, scale: 2
  end
end
