require 'rails_helper'

describe 'DELETE api/v1/targets/:id', type: :request do
  let(:user)               { create(:user) }
  let!(:target)            { create(:target, user: user) }
  let(:other_users_target) { create(:target) }
  let(:unexisting_target)  { 'unexisting_id' }

  context 'for an existing target' do
    context 'when deleting an own target' do
      it 'returns a successful response' do
        delete api_v1_target_path(target.id), headers: auth_headers, as: :json
        expect(response).to have_http_status(:success)
      end

      it 'deletes the target' do
        expect do
          delete api_v1_target_path(target.id), headers: auth_headers, as: :json
        end.to change(user.targets, :count).by(-1)
      end

      it 'can not delete twice' do
        headers = auth_headers
        delete api_v1_target_path(target.id), headers: headers, as: :json
        delete api_v1_target_path(target.id), headers: headers, as: :json
        expect(response).to_not have_http_status(:success)
      end
    end

    context 'when deleting other user\'s target' do
      it 'does not return a successful response' do
        delete api_v1_target_path(other_users_target.id), headers: auth_headers, as: :json
        expect(response).to_not have_http_status(:success)
      end

      it 'does not delete the target' do
        expect do
          delete api_v1_target_path(other_users_target.id), headers: auth_headers, as: :json
        end.to change(user.targets, :count).by(0)
      end
    end
  end

  context 'for an unexisting target' do
    it 'does not return a successful response' do
      delete api_v1_target_path(unexisting_target), headers: auth_headers, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
