class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates :video, uniqueness: { scope: :user, message: 'Can only add a video to queue once per user' }
  validates :position, numericality: { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video
  default_scope { order(:position) }

  def rating
    review.rating if review
  end

  def rating=(stars)
    if review
      review.update_column(:rating, stars)
    else
      new_review = Review.new(reviewer: user, rating: stars, video: video)
      new_review.save(validate: false)
    end
  end

  def category_name
    category.name
  end

  private
  def review
    @review ||= video.reviews.find_by(reviewer: user)
  end
end
