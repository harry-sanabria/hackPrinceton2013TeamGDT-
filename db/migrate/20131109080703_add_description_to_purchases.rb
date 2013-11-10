class AddDescriptionToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :description, :text
  end
end
