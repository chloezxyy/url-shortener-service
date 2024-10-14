require 'rails_helper'

# This tests the UrlsController

RSpec.describe UrlsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    website_link = "http://www.google.com"

    context "with invalid attributes" do
      it 'does not create a new shortened url with empty original_url' do
        puts "inside invalid attributes"

        post :create, params: { url: { original_url: nil } }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(Url.last).to be_nil

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
        expect(json_response["errors"]).to eq("Original URL cannot be blank")
      end

      it 'does not create a new shortened url with invalid original_url' do
        post :create, params: { url: { original_url: "invalid_url" } }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(Url.last).to be_nil

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
        expect(json_response["errors"]).to eq([ "Original url is invalid" ])
      end
    end

    context "with valid attributes" do
      it 'creates a new shortened url with valid title' do
        post :create, params: { original_url: "http://www.example.com" }, as: :json

        expect(response).to have_http_status(:created)
        expect(Url.last.original_url).to eq("http://www.example.com")
        expect(Url.last.title).to eq("Example Domain")
      end
      it 'creates a new shortened url' do
        post :create, params: { original_url: website_link }, as: :json

        expect(response).to have_http_status(:created)
        expect(Url.last.original_url).to eq(website_link)

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("short_url")
        expect(json_response["short_url"]).to_not be_nil
      end

      it 'creates multiple short URLs for the same original URL' do
        post :create, params: { original_url: website_link }, as: :json
        first_short_url = JSON.parse(response.body)["short_url"]

        post :create, params: { url: { original_url: website_link } }, as: :json
        second_short_url = JSON.parse(response.body)["short_url"]

        expect(first_short_url).to_not eq(second_short_url)
      end
    end
  end
end
