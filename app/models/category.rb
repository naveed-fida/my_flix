class Category < ActiveRecord::Base
  has_many :videos
  validates_presence_of :name
  validates_uniqueness_of :name

  def recent_videos
    videos.first(6)
  end
end
