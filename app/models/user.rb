class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy
  
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  has_many :friends, foreign_key: "request_from_id", dependent: :destroy
  has_many :requested_to_users, through: :friends, source: :request_to
  
  has_many :reverse_friends, foreign_key: "request_to_id", 
							 class_name: "Friend",
							 dependent: :destroy
  has_many :requested_from_users, through: :reverse_friends, source: :request_from
  
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
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end
  # Follow user methond
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  
  def self.name_search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
     find(:all)
    end
  end

  # Friend making method
  def friend?(other_user)
    friends.find_by_request_to_id(other_user.id) && other_user.friends.find_by_request_to_id(self.id)

  end

  def send_request?(other_user)
    friends.find_by_request_to_id(other_user.id)

  end
  
  def friend!(other_user)
    friends.create(request_to_id: other_user.id, status: false)
  end
  # Create remember token for user
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
	
	
  
end
