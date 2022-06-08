require 'rails_helper'

RSpec.describe "Roots", type: :request do
  describe "GET /:slug" do
    before(:each) do
      @url = Url.find_or_create!(long_url: 'https://www.google.com')
    end

    it 'should redirect to long_url given a valid slug' do
      get root_router_path(slug: @url.slug)
      expect(response.status).to eq(301)
      expect(response).to redirect_to(@url.long_url)
    end

    it 'should return 404 when given a invalid slug' do
      get root_router_path(slug: '#*asd')
      expect(response.status).to eq(404)
      json = JSON.parse(response.body).deep_symbolize_keys!
      expect(json[:message]).to eq('Slug not found')
    end

    it 'should return 404 when given a empty slug' do
      get root_router_path(slug: '')
      expect(response.status).to eq(404)
      json = JSON.parse(response.body).deep_symbolize_keys!
      expect(json[:message]).to eq('Slug not found')
    end
  end
end
