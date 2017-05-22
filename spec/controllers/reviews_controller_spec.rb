describe ReviewsController do
  context('Authorized user') do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    before do
      session[:user_id] = user.id
    end

    context('valid data') do
      before do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
      end

      it 'redirects to video show path' do
        expect(response).to redirect_to video_path(video.id)
      end
      it 'Saves the review' do
        expect(Review.count).to eq(1)
      end
      it 'associates review with the vido' do
        expect(Review.first.video).to eq(video)
      end
      it 'associates review with current user' do
        expect(Review.first.reviewer).to eq(user)
      end
    end

    context('invalid data') do
      before do
        post :create, video_id: video.id, review: {content: Faker::Lorem.paragraph(3)}
      end
      it 'does not save the review on invalid input' do
        expect(Review.count).to be(0)
      end
      it 'renders videos/show template on invalid input' do
        expect(response).to render_template('videos/show')
      end
      it 'sets @video' do
        expect(assigns(:video)).to eq(video)
      end
      it 'sets @reviews' do
        expect(assigns(:reviews)).to eq(video.reviews)
      end
      it 'sets @review' do
        expect(assigns(:review)).to be_instance_of(Review)
      end
    end
  end

  context('Unauthenticated user') do

  end
end
