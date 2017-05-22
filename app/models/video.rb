class Video < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items
  belongs_to :category
  default_scope {order('created_at DESC')}

  validates_presence_of :title, :description

  class << self
    def search_by_title(title)
      return [] if title.blank?
      where('title LIKE ?', "%#{title}%").order('created_at DESC')
    end
  end
end
