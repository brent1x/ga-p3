class User < ActiveRecord::Base
  has_secure_password
  validates :email, uniqueness: true
  has_many :cues
  has_many :user_restaurants
  has_many :restaurants, through: :user_restaurants

def self.check_if_user_exists user_email
    exists?(email: user_email)
end

def self.find_user user_email
	find_by(email: user_email)
end

def check_password password
	authenticate(password)

end

end
