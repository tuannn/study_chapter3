class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  # Define email gerular express  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Validate email is unique before save to database
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  
  # Validate for Model
  validates :name, 	presence: true, length: { maximum: 50} # validate for name
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false}  # validate for email
  validates	:password,	presence: true, length: { minimum: 6 } #validate for password
  validates	:password_confirmation,	presence: true, length: { minimum: 6 } #validate for password_confirmation
  
  # Check after validates:
  after_validation { self.errors.messages.delete(:password_digest) }
  
  # Create remember token for user
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
  
end
