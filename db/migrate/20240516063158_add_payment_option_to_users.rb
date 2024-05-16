class AddPaymentOptionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :payment_option, :string
  end
end
