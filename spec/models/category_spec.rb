describe Category, type: :model do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe '#recent_videos' do
    it 'returns videos in reverse chronological order' do
      comedies = Category.create(name: 'Comedy')
      futurama = Video.create(title: 'Futurama', description: 'Space Travel', category: comedies)
      back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel', created_at: 1.day.ago, category: comedies)

      expect(comedies.recent_videos).to eq([futurama, back_to_future])
    end

    it 'returns less than six videos if there are less than six videos' do
      comedies = Category.create(name: 'Comedy')
      futurama = Video.create(title: 'Futurama', description: 'Space Travel', category: comedies)
      back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel', created_at: 1.day.ago, category: comedies)

      expect(comedies.recent_videos.count).to eq(2)
    end

    it 'returns six videos if there are more than six videos' do
      comedy = Category.create(name: 'Comedy')
      7.times { |n| Video.create(title: "Video #{n}", description: "Desc#{n}", category: comedy)}

      expect(comedy.recent_videos.count).to eq(6)
    end

    it 'returns the most recent six videos' do
      comedy = Category.create(name: 'Comedy')
      7.times { |n| Video.create(title: "Video #{n}", description: "Desc#{n}", category: comedy)}
      conan = Video.create(title: 'Conan', description: 'Talk Show', category: comedy, created_at: 1.day.ago)

      expect(comedy.recent_videos).to_not include(conan)
    end

    it 'returns an empty array if the category does not have a video' do
      wild_life = Category.create(name: 'Wild Life')
      expect(wild_life.recent_videos).to eq([])
    end
  end
end
