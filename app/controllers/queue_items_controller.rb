class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    create_queue_item(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if queue_item.user == current_user
      queue_item.destroy
      current_user.normalize_queue_items_positions
    end
    redirect_to my_queue_path
  end

  def batch_update
    begin
      update_queue_items
      current_user.normalize_queue_items_positions
    rescue ActiveRecord::RecordInvalid
      flash[:error] = 'Invalid position numbers.'
    end

    redirect_to my_queue_path
  end

  private
  def create_queue_item(video)
    QueueItem.create(video: video, user: current_user, position: QueueItem.count + 1)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params['queue_items'].each do |item_data|
        queue_item = QueueItem.find(item_data['id'])
        queue_item.update_attributes!(position: item_data['position'], rating: item_data['rating']) if queue_item.user == current_user
      end
    end
  end
end
