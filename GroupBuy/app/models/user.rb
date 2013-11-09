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

  def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
end
