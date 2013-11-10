class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :purchase
  validates :user_id, presence:true
  validates :purchase_id, presence:true
  validates :price, presence: true, :numericality => {:greater_than => 0}
  attr_accessible :user_id, :purchase_id, :price, :description
end
