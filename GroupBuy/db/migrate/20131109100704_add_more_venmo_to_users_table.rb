class AddMoreVenmoToUsersTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :venmo_username
    end
  end
end
