require 'rails_helper'

describe 'Performance Data' do
  let(:user) { FactoryGirl.create(:user) }
  let(:headers) { {HTTP_ACCEPT: 'application/json'} }
  let(:credentials) { user.create_new_auth_token }

  describe 'POST /api/v1/data/' do
    it 'creates a data entry' do
      post '/api/v1/data/', {params: {performance_data: {data: {message: 'Average'}}}, headers: headers.merge!(credentials)}
      entry = PerformanceData.last
      expect(entry.data).to eq({'message'=>'Average'})
    end

  end
  describe 'GET /api/v1/data/' do
    before do
      5.times { user.performance_data.create(data: {message: 'Average'}) }
    end

    it 'returns a collection' do
      get '/api/v1/data/', {params: {}, headers: headers.merge!(credentials)}
      expect(response_json['entries'].count).to eq 5
    end
  end

end
