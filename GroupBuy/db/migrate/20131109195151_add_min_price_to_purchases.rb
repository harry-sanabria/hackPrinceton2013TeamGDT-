class AddMinPriceToPurchases < ActiveRecord::Migration
  def change
  	change_table :purchases do |t|
  		t.remove :price
  		t.decimal :min_price
  		t.decimal :current_total_price
  	end
  end
end
