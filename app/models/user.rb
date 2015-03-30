class User < ActiveRecord::Base
  has_secure_password
  has_many :cues	

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
