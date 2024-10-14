require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'POST #create' do
    let(:valid_attributes) do
      {
        original_url: 'http://example.com',
        short_url: 'exmpl',
        title: 'Example'
      }
    end

    let(:invalid_attributes) do
      {
        original_url: '',
        short_url: '',
        title: ''
      }
    end

    context 'with valid params' do
      it 'creates a new Url and renders the show template' do
        expect {
          post :create, params: { url: valid_attributes }
        }.to change(Url, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response).to render_template(:show)
        expect(assigns(:url)).to be_a(Url)
        expect(assigns(:url)).to be_persisted
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable entity status and does not create a new Url' do
        expect {
          post :create, params: { url: invalid_attributes }
        }.not_to change(Url, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('errors')
        expect(assigns(:url)).to be_nil
      end
    end

    context 'when an exception occurs during save' do
      before do
        allow_any_instance_of(Url).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'returns unprocessable entity status and does not create a new Url' do
        expect {
          post :create, params: { url: valid_attributes }
        }.not_to change(Url, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('errors')
        expect(assigns(:url)).to be_nil
      end
    end
  end
end
