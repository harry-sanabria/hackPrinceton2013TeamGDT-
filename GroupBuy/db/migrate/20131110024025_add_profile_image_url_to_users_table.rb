class AddProfileImageUrlToUsersTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :image_url
    end
  end
end
