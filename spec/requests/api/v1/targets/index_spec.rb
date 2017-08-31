require 'rails_helper'

describe 'GET api/v1/targets', type: :request do
  let(:user)                  { create :user }
  let(:other_user)            { create :user }
  let!(:targets)              { create_list :target, 5, user: user }
  let!(:not_expected_targets) { create_list :target, 5 }

  it 'returns success' do
    get api_v1_targets_path, headers: auth_headers, as: :json
    expect(response).to have_http_status(:success)
  end

  it 'returns my targets' do
    get api_v1_targets_path, headers: auth_headers, as: :json
    expect(json[:targets].map { |hash| hash[:target][:id] })
      .to match_array(targets.pluck(:id))
  end

  it 'does NOT return other person\'s target' do
    get api_v1_targets_path, headers: auth_headers, as: :json
    expect(json[:targets].map { |hash| hash[:target][:id] })
      .not_to include(*not_expected_targets.pluck(:id))
  end
end
