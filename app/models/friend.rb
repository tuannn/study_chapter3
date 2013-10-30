class Friend < ActiveRecord::Base
  attr_accessible :request_from_id, :request_to_id, :status
  
  belongs_to :request_to, class_name: "User"
  belongs_to :request_from, class_name: "User"
  #belongs_to :user
  
  validates :request_from_id, presence: true
  validates :request_to_id, presence: true
end
