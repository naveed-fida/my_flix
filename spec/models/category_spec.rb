require 'spec_helper'

describe Category, type: :model do
  it { should have_many(:videos) }
  it {should validate_uniqueness_of(:name)}

  describe '#recent_videos' do
    it 'returns videos in chronological order' do
      comedies = Category.create(name: 'Comedy')
      futurama = Video.create(title: 'Futurama', description: 'Space Travel')
      back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel', created_at: 1.day.ago)
      comedies.videos << futurama
      comedies.videos << back_to_future

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
      7.times { |n| Video.create(title: "Video #{n}", description: "Desc #{n}", category: comedy)}

      expect(comedy.recent_videos.count).to eq(6)
    end
  end
end
