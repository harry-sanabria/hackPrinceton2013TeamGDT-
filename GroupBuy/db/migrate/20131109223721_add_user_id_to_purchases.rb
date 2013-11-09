class AddUserIdToPurchases < ActiveRecord::Migration
  def change
    change_table :purchases do |t|
      t.integer "user_id"
    end
  end
end
