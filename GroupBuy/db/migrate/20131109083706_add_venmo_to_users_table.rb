class AddVenmoToUsersTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :venmo_code
    end
  end
end
