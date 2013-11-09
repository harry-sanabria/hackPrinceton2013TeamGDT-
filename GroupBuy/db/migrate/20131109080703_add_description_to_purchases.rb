class AddDescriptionToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :description, :textfield
  end
end
