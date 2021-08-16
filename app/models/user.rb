class User < ApplicationRecord
  has_secure_password
  
  validates :user_code, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :user_anme, presence: true, length: { maximum: 50 }
  validates :password_digest, presence: true, length { minimum: 8 }
end
