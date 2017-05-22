class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items
  validates_presence_of :name, :password, :email
  validates_uniqueness_of :email

  has_secure_password validations: false

  def normalize_queue_items_positions
    queue_items.each_with_index do |item, idx|
      item.update_attributes(position: idx + 1)
    end
  end
end
