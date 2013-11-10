class AddFieldsToPayments < ActiveRecord::Migration
  def change
  	change_table :payments do |t|
  		t.remove :part
  		t.decimal :price
  		t.text :description
  	end
  end
end
