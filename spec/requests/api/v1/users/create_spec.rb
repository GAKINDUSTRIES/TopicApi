require 'rails_helper'

describe 'POST api/v1/users/', type: :request do
  let!(:user)           { create(:user) }
  let(:failed_response) { 422 }

  describe 'POST create' do
    let(:username)              { 'test' }
    let(:email)                 { 'test@test.com' }
    let(:password)              { '12345678' }
    let(:password_confirmation) { '12345678' }

    let(:params) do
      {
        user: {
          username: username,
          email: email,
          gender: 'male',
          password: password,
          password_confirmation: password_confirmation
        }
      }
    end

    it 'returns a successful response' do
      post user_registration_path, params: params, as: :json

      expect(response).to have_http_status(:success)
    end

    it 'creates the user' do
      post user_registration_path, params: params, as: :json

      new_user = User.find_by_email(email)
      expect(new_user).to_not be_nil
    end

    context 'when the email is not correct' do
      let(:email) { 'invalid_email' }

      it 'does not create a user' do
        expect do
          post user_registration_path, params: params, as: :json
        end.not_to change { User.count }
      end

      it 'does not return a successful response' do
        post user_registration_path, params: params, as: :json

        expect(response.status).to eq(failed_response)
      end
    end

    context 'when the password is incorrect' do
      let(:password)              { 'short' }
      let(:password_confirmation) { 'short' }

      let(:new_user)              { User.find_by_email(email) }

      it 'does not create a user' do
        post user_registration_path, params: params, as: :json

        expect(new_user).to be_nil
      end

      it 'does not return a successful response' do
        post user_registration_path, params: params, as: :json

        expect(response.status).to eq(failed_response)
      end
    end

    context 'when passwords don\'t match' do
      let(:password)              { 'shouldmatch' }
      let(:password_confirmation) { 'dontmatch' }

      let(:new_user)              { User.find_by_email(email) }

      it 'does not create a user' do
        post user_registration_path, params: params, as: :json

        expect(new_user).to be_nil
      end

      it 'does not return a successful response' do
        post user_registration_path, params: params, as: :json

        expect(response.status).to eq(failed_response)
      end
    end
  end
end
