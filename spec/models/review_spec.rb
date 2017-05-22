describe Review do
  it { should belong_to :video }
  it { should belong_to :reviewer }
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:reviewer) }
  it { should validate_presence_of(:video) }
  it { should validate_presence_of(:content) }

  describe '#reviewer_name' do
    it 'returns the name of the reviewer associated' do
      video = Fabricate(:video)
      alice = Fabricate(:user)
      review = Fabricate(:review, video: video, reviewer: alice)

      expect(review.reviewer_name).to eq(alice.name)
    end
  end
end
