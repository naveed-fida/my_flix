describe SessionsController do
  describe 'GET new' do
    it 'renders new template if user not logged in' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'redirects to home path if user is already logged_in' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    context('When credentials valid') do
      let(:user) { Fabricate(:user) }

      before do
        post :create, password: user.password, email: user.email
      end

      it 'stores login message in flash notice' do
        expect(flash[:notice]).to eq('You have been signed in')
      end
      it 'stores the correct user_id in the session' do
        expect(session[:user_id]).to eq(user.id)
      end
      it 'redirects user to home path' do
        expect(response).to redirect_to home_path
      end
    end

    context('When password invalid') do
      let(:user) { Fabricate(:user) }

      before do
        post :create, password: 'wrong_password', email: user.email
      end

      it 'does not store user_id in the session' do
        expect(session[:user_id]).to be_nil
      end
      it 'stores error message in flash ' do
        expect(flash[:error]).to eq('Invalid username or password')
      end
      it 'renders new template' do
        expect(response).to render_template(:new)
      end
    end

    context('When email invalid') do
      let(:user) { Fabricate(:user) }

      before do
        post :create, password: user.password, email: 'wrong_email'
      end

      it 'does not store user_id in the session' do
        expect(session[:user_id]).to be_nil
      end
      it 'stores error message in flash ' do
        expect(flash[:error]).to eq('Invalid username or password')
      end
      it 'renders new template' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET destroy' do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it 'stores notice in flash' do
      expect(flash[:notice]).to eq('You are signed out')
    end
    it 'deletes user_id from session' do
      expect(session[:user_id]).to be_nil
    end
    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end
end
