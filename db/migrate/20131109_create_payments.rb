class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :payment_id
      t.integer :part

      t.timestamps
    end
  end
end