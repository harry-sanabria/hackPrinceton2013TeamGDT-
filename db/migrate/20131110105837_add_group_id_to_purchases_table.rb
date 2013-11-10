class AddGroupIdToPurchasesTable < ActiveRecord::Migration
  def change
    change_table :purchases do |t|
      t.string :group_id
    end
  end
end
