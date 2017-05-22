describe VideosController do
  describe 'GET :show' do
    context('user authenticated') do
      let(:video) { Fabricate(:video) }
      let(:user) { Fabricate(:user) }

      before do
        session[:user_id] = user.id
        get :show, id: video.id
      end

      it 'sets @video' do
        expect(assigns(:video)).to eq(video)
      end

      it 'sets @reviews' do
        review1 = Fabricate(:review, video: video, reviewer: user)
        review2 = Fabricate(:review, video: video, reviewer: user)
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end

    it 'redirects to sign-in path if user unauthenticated' do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to(sign_in_path)
    end
  end

  describe 'GET :search' do
    it 'redirects to sign-in path if user unauthenticated' do
      video = Fabricate(:video)
      get :search, search_term: 'something'
      expect(response).to redirect_to(sign_in_path)
    end

    it 'sets @videos in case of authenticated user' do
      video = Fabricate(:video)
      session[:user_id] = Fabricate(:user).id
      get :search, search_term: video.title[3..-1]
      expect(assigns[:videos]).to eq([video])
    end
  end
end
