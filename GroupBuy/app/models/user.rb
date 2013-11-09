class User < ActiveRecord::Base
  attr_accessible :username, :name, :password, :password_confirmation
  attr_accessor :password
  before_save :encrypt_PW

  validates :username, presence: true
  validates :name, presence: true
  validates_uniqueness_of :username
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create

  has_many :payments, dependent: :destroy
  has_many :purchases, :through => :payments

  def encrypt_PW
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def self.authenticate(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.username = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end
