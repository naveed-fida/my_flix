class Review < ActiveRecord::Base
  belongs_to :reviewer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :video
  validates_presence_of :rating, :reviewer, :video, :content
  
  delegate :name, to: :reviewer, prefix: :reviewer
end
