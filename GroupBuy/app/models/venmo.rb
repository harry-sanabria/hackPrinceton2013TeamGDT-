class Venmo < ActiveRecord::Base
  validates :venmo_id, presence: true
  validates :token, presence: true
  validates :refresh_code, presence: true
  
  belongs_to :user
  
  attr_protected
end
