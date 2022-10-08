require 'rails_helper'
require 'json'
require 'support/factory_bot'

describe 'User requests', type: :request do
  before(:each) do
    @client = FactoryBot.create(:user_client)
    @corporation = FactoryBot.create(:user_corporation)
  end

  describe 'GET REQUESTS' do
    context "ROOT" do
      it 'returns status 200 without user signed in' do
        get root_path

        expect(response).to(have_http_status(200))
      end
    end

    context 'User Index' do
      it 'returns status 200 if user is authorized' do
        login_as(@corporation)
        get users_path

        expect(response).to(have_http_status(200))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@client)
        get users_path

        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(root_path))
      end
    end

    context 'User Show' do
      it 'returns status 200 if user is authorized' do
        login_as(@corporation)
        get users_path

        expect(response).to(have_http_status(200))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@client)
        get users_path

        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(root_path))
      end
    end

    context 'User New' do
      it 'returns status 200 if user is authorized' do
        login_as(@corporation)
        get new_user_path

        expect(response).to(have_http_status(200))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@client)
        get new_user_path

        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(root_path))
      end
    end

    context 'User Edit' do
      it 'returns status 200 if user is authorized' do
        login_as(@corporation)
        get edit_user_path(@client.id)

        expect(response).to(have_http_status(200))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@client)
        get edit_user_path(@client.id)

        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(root_path))
      end
    end


    context 'Dashboard New' do
      it 'returns status 302 and redirects to "dashboard_user_path"' do
        login_as(@client)
        get new_dashboard_path

        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(dashboard_user_path(@client.id)))
      end
    end

    context 'Dashboard::User Show' do
      it 'returns status 200 if user is authorized' do
        login_as(@client)
        get dashboard_user_path(@client.id)

        expect(response).to(have_http_status(200))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@corporation)
        get dashboard_user_path(@client.id)

        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(root_path))
      end
    end
  end

  describe 'POST REQUESTS' do
    context 'User Create' do
      it 'returns status 302 and redirects to "users_path" if user is authorized; creates Reward Record, Tier Control and Reward Elegible records' do
        login_as(@corporation)
        post users_path(
          user: {
            email: "test@test.com",
            password: 123456,
            user_type: "client",
            birthday: Faker::Date.birthday,
            country: User::COUNTRIES.sample
          }
        )
        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(users_path))
        expect(TierControl.count).to eq(1)
        expect(RewardElegible.count).to eq(1)
      end

      it 'returns status 302 and redirects to "new_user_path"  if user is authorized BUT new user NOT created' do
        login_as(@corporation)
        post users_path(
          user: {
            email: "satoshi@nakamoto.com",
            password: 123456,
            user_type: "client",
            birthday: Faker::Date.birthday,
            country: User::COUNTRIES.sample
          }
        )
        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(new_user_path))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@client)
        post users_path(
          user: {
            email: "test@test.com",
            password: 123456,
            user_type: "client",
            birthday: Faker::Date.birthday,
            country: User::COUNTRIES.sample
          }
        )
        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(root_path))
      end
    end
  end

  describe 'PATCH REQUESTS' do
    context 'User Update' do
      it 'returns status 302 and redirects to "users_path" if user is authorized' do
        login_as(@corporation)
        patch user_path(
          id: @client.id,
          user: {
            email: "son@gohan.com",
            birthday: Faker::Date.birthday,
            country: User::COUNTRIES.sample
          }
        )
        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(users_path))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@client)
        patch user_path(
          id: @client.id,
          user: {
            email: "son@goku.com",
            birthday: Faker::Date.birthday,
            country: User::COUNTRIES.sample
          }
        )
        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(root_path))
      end
    end

    context 'Dashboard::User Update' do
      it 'returns status 302 and redirects to "user_path" if user is authorized' do
        login_as(@client)
        patch dashboard_user_path(@client.id)

        expect(response).to(redirect_to(dashboard_user_path(@client.id)))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@corporation)
        patch dashboard_user_path(@client.id)

        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(root_path))
      end
    end
  end

  describe 'DELETE REQUESTS' do
    context "User Destroy" do
      it 'returns status 302 and redirects to "users_path" if user is authorized' do
        login_as(@corporation)
        delete user_path(@client.id)

        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(users_path))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@client)
        delete user_path(@client.id)

        expect(response).to(have_http_status(302))
        expect(response).to(redirect_to(root_path))
      end
    end
  end
end
