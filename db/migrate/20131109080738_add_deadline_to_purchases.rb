class AddDeadlineToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :deadline, :text
  end
end
