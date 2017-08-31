require 'rails_helper'

describe 'GET api/v1/topics', type: :request do
  let(:user) { create :user }
  let!(:topics) { create_list :topic, 5 }

  it 'returns success' do
    get api_v1_topics_path, headers: auth_headers, as: :json
    expect(response).to have_http_status(:success)
  end

  it 'returns all topics' do
    get api_v1_topics_path, headers: auth_headers, as: :json
    expect(json[:topics].map { |topic| topic[:name] })
      .to match_array(topics.pluck(:name))
  end
end
