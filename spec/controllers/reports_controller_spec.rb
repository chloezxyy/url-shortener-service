# spec/controllers/reports_controller_spec.rb
require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @reports and @click_counts' do
      # to isolate the controller from the model so we just return a string
      allow(controller).to receive(:aggregate_by_urls).and_return('reports_data')
      allow(controller).to receive(:aggregate_by_clicks).and_return('click_counts_data')

      get :index

      expect(assigns(:reports)).to eq('reports_data')
      expect(assigns(:click_counts)).to eq('click_counts_data')
    end

    it 'handles errors gracefully' do
      # json: { error: e.message }
      allow(controller).to receive(:aggregate_by_urls).and_raise(StandardError.new('error message'))

      get :index

      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)['error']).to eq('error message')
    end
  end

  describe 'GET reports#index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @reports' do
      allow(controller).to receive(:aggregate_by_urls).and_return('reports_data')

      get :index

      expect(assigns(:reports)).to eq('reports_data')
    end

    it 'handles errors gracefully' do
      allow(controller).to receive(:aggregate_by_urls).and_raise(StandardError.new('error message'))

      get :index

      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)['error']).to eq('error message')
    end
  end

  describe 'GET #click_count' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @click_counts' do
      allow(controller).to receive(:aggregate_by_clicks).and_return('click_counts_data')

      get :index

      expect(assigns(:click_counts)).to eq('click_counts_data')
    end

    it 'handles errors gracefully' do
      allow(controller).to receive(:aggregate_by_clicks).and_raise(StandardError.new('error message'))

      get :index

      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)['error']).to eq('error message')
    end
  end
end
