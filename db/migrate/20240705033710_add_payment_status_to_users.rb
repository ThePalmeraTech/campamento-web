class AddPaymentStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :payment_status, :string
    add_column :users, :second_payment_proof, :string
  end
end
