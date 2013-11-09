class Payment < ActiveRecord::Base
  belongs_to:user
  belongs_to:purchase
  validates :part, presence: true, :numericality => {:greater_than => 0}
  attr_accessible :part
end
