class CreateVenmos < ActiveRecord::Migration
  def change
    create_table :venmos do |t|
      t.belongs_to :user
      
      t.string :username
      t.string :venmo_id
      t.string :refresh_code
      t.string :token
      t.integer :user_id
      
      t.timestamps
    end
  end
end
