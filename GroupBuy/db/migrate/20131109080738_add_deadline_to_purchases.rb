class AddDeadlineToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :deadline, :textfield
  end
end
