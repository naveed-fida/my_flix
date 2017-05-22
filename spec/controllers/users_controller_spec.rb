describe UsersController do
  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    context('with valid input') do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      it 'saves user to database' do
        expect(User.count).to be(1)
      end
      it 'redirects to sign in path' do
        expect(response).to redirect_to sign_in_path
      end
    end

    context('with invalid input') do
      before do
        post :create, user: {name: Faker::Name.name, email: Faker::Internet.email}
      end

      it 'does not save the user' do
        expect(User.count).to eq(0)
      end
      it 'renders template :new with errors if user not saved' do
        expect(response).to render_template :new
      end
      it 'set @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end
