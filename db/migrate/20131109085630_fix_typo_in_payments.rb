class FixTypoInPayments < ActiveRecord::Migration
  def change
  	change_table :payments do |t|
  		t.remove :payment_id
  		t.integer :purchase_id
  	end
  end
end
