class ChangeUserTableForFacebookAuth < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :password_hash, :password_salt
      t.string :oauth_token
      t.string :provider
      t.string :uid
      t.datetime :oauth_expires_at
    end
  end
end
