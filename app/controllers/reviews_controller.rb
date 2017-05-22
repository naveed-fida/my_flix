class ReviewsController < ApplicationController

  def create
    @video = Video.find(params[:video_id])
    if new_review.save
      redirect_to @video
    else
      @review = new_review
      @reviews = @video.reviews
      render 'videos/show'
    end
  end

  private
  # def review_attributes
  #   form_params = params[:review]
  #   form_params.merge({video: Video.find(params[:video_id]), :user: current_user})
  # end
  def new_review
    vid_and_user = { video: @video, reviewer: current_user }
    Review.new(params.require(:review).permit(:rating, :content).merge(vid_and_user))
  end
end
