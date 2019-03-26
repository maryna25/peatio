# encoding: UTF-8
# frozen_string_literal: true

describe API::V2::Account::History, type: :request do
  let(:member) { create(:member, :level_3) }
  let(:other_member) { create(:member, :level_3) }
  let(:token) { jwt_for(member) }
  let(:level_0_member) { create(:member, :level_0) }
  let(:level_0_member_token) { jwt_for(level_0_member) }

  describe 'GET /api/v2/account/history' do
    before do
    end

    it 'requires authentication' do
      api_get '/api/v2/account/history'
      expect(response.code).to eq '401'
    end

    it 'returns history with auth token' do
      api_get '/api/v2/account/history', token: token
      expect(response).to be_success
    end

    it 'returns history with valid params' do
      api_get '/api/v2/account/history', params: { filter: 'deposit+withdraw', sort: 'created_at', order: 'asc' }, token: token
      expect(response).to be_success
    end

    it 'returns error with invalid filter param' do
      api_get '/api/v2/account/history', params: { filter: 'test' }, token: token
      expect(response.code).to eq '422'
      expect(response).to include_api_error('account.history.filter.invalid')
    end

    it 'returns error with invalid sort param' do
      api_get '/api/v2/account/history', params: { sort: 'test' }, token: token
      expect(response.code).to eq '422'
      expect(response).to include_api_error('account.history.sort.invalid')
    end

    it 'returns error with invalid order param' do
      api_get '/api/v2/account/history', params: { sort: 'created_at', order: 'test' }, token: token
      expect(response.code).to eq '422'
      expect(response).to include_api_error('account.history.order.invalid')
    end

  end
end
