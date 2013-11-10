class AddStateToPurchases < ActiveRecord::Migration
  def change
    change_table :purchases do |t|
      t.integer "state"
    end
  end
end
