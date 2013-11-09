class ChangeInvitedGroupToGroup < ActiveRecord::Migration
  def change
  	change_table :purchases do |t|
    	t.remove :invited_group
    	t.string :group
	end
  end
end
