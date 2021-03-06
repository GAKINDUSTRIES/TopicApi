require 'rails_helper'

describe 'POST api/v1/users/sign_in', type: :request do
  let(:password) { 'password' }
  let(:user)     { create(:user, password: password) }

  context 'with correct params' do
    before do
      params = {
        user:
          {
            email: user.email,
            password: password
          }
      }
      post new_user_session_path, params: params, as: :json
    end

    it 'returns success' do
      expect(response).to be_success
    end

    it 'returns the user' do
      avatar_params = {
        url:         nil,
        normal:      { url: nil },
        small_thumb: { url: nil }
      }

      response_expected = {
        id:         user.id,
        email:      user.email,
        username:   user.username,
        uid:        user.email,
        provider:   'email',
        first_name: user.first_name,
        gender:     user.gender,
        last_name:  user.last_name,
        push_token: user.push_token,
        avatar:     avatar_params
      }.with_indifferent_access
      expect(json[:data]).to eq(response_expected)
    end

    it 'returns a valid client and access token' do
      token = response.header['access-token']
      client = response.header['client']
      expect(user.reload.valid_token?(token, client)).to be_truthy
    end
  end

  context 'with incorrect params' do
    it 'return errors upon failure' do
      params = {
        user: {
          email: user.email,
          password: 'wrong_password!'
        }
      }
      post new_user_session_path, params: params, as: :json

      expect(response).to be_unauthorized
      expected_response = {
        errors: ['Invalid login credentials. Please try again.']
      }.with_indifferent_access
      expect(json).to eq(expected_response)
    end
  end
end
