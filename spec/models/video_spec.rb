describe Video, type: :model do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }

  describe 'search_by_title' do
    it 'returns empty array if no match' do
      Video.create(title: 'Hello Ladies', description: 'Some desc')
      expect(Video.search_by_title('Lala')).to eq([])
    end
    it 'returns an array of one video for an exact match' do
      back_to_future = Video.create(title: 'Back to the future', description: 'Time travel')
      kill_bill = Video.create(title: 'Kill Bill', description: 'Action')

      expect(Video.search_by_title('Back to the future')).to eq([back_to_future])
    end
    it 'returns an array of one video for a partial match' do
      back_to_future = Video.create(title: 'Back to the future', description: 'Time travel')
      kill_bill = Video.create(title: 'Kill Bill', description: 'Action')

      expect(Video.search_by_title('Kill')).to eq([kill_bill])
    end
    it 'returns an array of all matches ordered by created_at' do
      h1 = Video.create(title: 'Happiness', description: 'Some desc')
      h2 = Video.create(title: 'The Hangover', description: 'Hillarious Comedy', created_at: 1.day.ago)

      expect(Video.search_by_title('H')).to eq([h1, h2])
    end
    it 'returns empty array for a search with empty string' do
      h1 = Video.create(title: 'Happiness', description: 'Some desc')
      h2 = Video.create(title: 'The Hangover', description: 'Hillarious Comedy', created_at: 1.day.ago)

      expect(Video.search_by_title('')).to eq([])
    end
  end
end
