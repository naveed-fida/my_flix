describe QueueItem do
  it { should belong_to(:video) }
  it { should belong_to (:user) }

  describe '#video_title' do
    it 'returns the title of the assocaited video' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe '#rating' do
    it 'returns the rating for the video by the user if the review is present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      review = Fabricate(:review, video: video, reviewer: user)

      expect(queue_item.rating).to eq(review.rating)
    end
    it 'returns nil if the review is not present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)

      expect(queue_item.rating).to eq(nil)
    end
  end

  describe '#rating=' do
    it 'changes the rating of the review if the review is present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, reviewer: user, video: video, rating: 3)

      queue_item = Fabricate(:queue_item, video: video, user: user)

      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it 'clears the rating of the review if the review is present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, reviewer: user, video: video, rating: 3)

      queue_item = Fabricate(:queue_item, video: video, user: user)

      queue_item.rating = nil
      expect(Review.first.rating).to eq(nil)
    end

    it 'creates a review with the rating if the review is not present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)

      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end

  describe '#category_name' do
    it "returns the associated video's category's name" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video, user: Fabricate(:user))

      expect(queue_item.category_name).to eq(category.name)
    end
  end

  describe '#category' do
    it 'returns the category of the associated video' do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video, user: Fabricate(:user))

      expect(queue_item.category).to eq(category)
    end
  end
end
