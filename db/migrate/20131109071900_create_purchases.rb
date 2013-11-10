class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
    	t.string :title
      	t.decimal :price
      	t.string :invited_group

    	t.timestamps
    end
  end
end
