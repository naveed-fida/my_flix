class Video < ActiveRecord::Base
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
