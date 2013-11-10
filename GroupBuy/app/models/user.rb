class User < ActiveRecord::Base
  validates :username, presence: true
  validates :name, presence: true
  validates_uniqueness_of :username

  has_many :payments, dependent: :destroy
  has_many :purchases
  has_one :venmo, dependent: :destroy

  def self.authenticate(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.username = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.image_url = auth.info.image
      user.save!
    end
  end
end
