describe QueueItemsController do
  context 'Authenticated user' do
    let(:user) { Fabricate(:user) }

    before do
      session[:user_id] = user.id
    end

    context 'GET index' do
      before do
        user.queue_items << Fabricate(:queue_item)
        user.queue_items << Fabricate(:queue_item, video: Fabricate(:video))
        get :index
      end

      it 'sets @queue_items to current user queue items' do
        expect(assigns(:queue_items)).to eq(user.queue_items)
      end
      it 'renders template :index' do
        expect(response).to render_template(:index)
      end
    end

    context 'POST create' do
      let(:video) { Fabricate(:video) }
      before do |example|
        unless example.metadata[:skip_before]
          post :create, video_id: video.id
        end
      end

      it 'should redirect to my_queue page' do
        expect(response).to redirect_to my_queue_path
      end
      it 'saves a queue_item to the db' do
        expect(QueueItem.count).to eq(1)
      end
      it 'creates a queue item that is associated with current_user' do
        expect(QueueItem.first.user).to eq(user)
      end
      it 'creates a queue item that is associated with the video whose id is passed' do
        expect(QueueItem.first.video).to eq(video)
      end
      it 'puts the queue item as the last one', :skip_before do
        south_park = Fabricate(:video, title: 'South Park', category: Fabricate(:category, name: 'Unique Name'))
        Fabricate(:queue_item, video: south_park, user: user)
        post :create, video_id: video.id
        video_queue_item = QueueItem.find_by(video: video)

        expect(video_queue_item.position).to eq(2)
      end
      it 'does not add the queue item if it already exists', :skip_before do
        queue_item = Fabricate(:queue_item, video: video, user: user)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
    end

    context 'DELETE destroy' do
      let(:video) { Fabricate(:video) }

      it 'redirects to my_queue_page' do
        queue_item = Fabricate(:queue_item, video: video, user: user)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
      it 'deletes the queue_item' do
        queue_item = Fabricate(:queue_item, video: video, user: user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end
      it 'should not delete the queue item if the current user does not own it' do
        alice = Fabricate(:user, email: 'alice@example.com')
        queue_item = Fabricate(:queue_item, video: video, user: alice)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end

      it 'should normalize the remaining queue_items if one is removed' do
        queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: Fabricate(:video))
        queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: Fabricate(:video, category: Fabricate(:category, name: 'Historical')))
        delete :destroy, id: queue_item1.id

        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context 'PATCH batch_update' do
      context 'valid input' do
        it 'redirects to my_queue page' do
          queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: Fabricate(:video))
          queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: Fabricate(:video, category: Fabricate(:category, name: 'Historical')))
          post :batch_update, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(response).to redirect_to my_queue_path
        end
        it 'reorders queue items' do
          queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: Fabricate(:video))
          queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: Fabricate(:video, category: Fabricate(:category, name: 'Historical')))

          post :batch_update, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]

          expect(user.queue_items).to eq([queue_item2, queue_item1])
        end
        it 'normalizes the position numbers' do
          queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: Fabricate(:video))
          queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: Fabricate(:video, category: Fabricate(:category, name: 'Historical')))

          post :batch_update, queue_items: [{id: queue_item1.id, position: 5}, {id: queue_item2.id, position: 3}]

          expect(user.queue_items.map(&:position)).to eq([1, 2])
        end
      end
      context 'with invalid input' do
        it 'redirects to queue path' do
          queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: Fabricate(:video))
          queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: Fabricate(:video, category: Fabricate(:category, name: 'Historical')))

          post :batch_update, queue_items: [{id: queue_item1.id, position: 5}, {id: queue_item2.id, position: 3.5}]

          expect(response).to redirect_to(my_queue_path)
        end
        it 'sets flash error message' do
          queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: Fabricate(:video))
          queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: Fabricate(:video, category: Fabricate(:category, name: 'Historical')))

          post :batch_update, queue_items: [{id: queue_item1.id, position: 5}, {id: queue_item2.id, position: 3.5}]

          expect(flash[:error]).to_not be_blank
        end

        it 'does not change queue items' do
          queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: Fabricate(:video))
          queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: Fabricate(:video, category: Fabricate(:category, name: 'Historical')))

          post :batch_update, queue_items: [{id: queue_item1.id, position: 5}, {id: queue_item2.id, position: 3.5}]

          expect(queue_item1.reload.position).to eq(1)
        end

        it 'does not update queue items if they do not belong to current user' do
          alice = Fabricate(:user)
          queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: Fabricate(:video))
          queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: Fabricate(:video, category: Fabricate(:category, name: 'Historical')))

          post :batch_update, queue_items: [{id: queue_item1.id, position: 5}, {id: queue_item2.id, position: 2}]

          expect(queue_item1.reload.position).to eq(1)
          expect(queue_item2.reload.position).to eq(2)
        end
      end
    end
  end
  context 'Unathenticated user' do
    context 'GET index' do
      it 'redirects to sign in path' do
        get :index
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context 'POST create' do
      let(:video) { Fabricate(:video) }
      it 'redirects to the sign in page' do
        get :create, video_id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'Delete Destroy' do
      let(:video) { Fabricate(:video) }

      it 'redirects to the sign in page' do
        item = Fabricate(:queue_item, video: video, user: Fabricate(:user))
        delete :destroy, id: item.id
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'PATCH batch_update' do
      it 'redirects to sign in page' do
        post :batch_update, queue_items: [{id: 3, position: 5}, {id: 4, position: 3}]
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end
