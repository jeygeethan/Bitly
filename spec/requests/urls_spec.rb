require 'rails_helper'

RSpec.describe "Urls", type: :request do
  describe 'GET /urls/:slug' do
    before(:each) do
      @url = Url.find_or_create!(long_url: 'https://www.google.com')
    end

    it 'should have response 200 for hitting the show url for any valid slug' do
      get urls_show_path, params: { slug: @url.slug }
      expect(response.status).to eq(200)
    end

    it 'should throw bad request for hitting show url with blank slug' do
      get urls_show_path, params: { slug: '' }
      expect(response.status).to eq(400)
      json = JSON.parse(response.body).deep_symbolize_keys!
      expect(json[:message]).to eq('Slug is empty')
    end

    it 'should give valid long_url for a valid slug' do
      get urls_show_path, params: { slug: @url.slug }
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys!
      expect(json[:long_url]).to eq(@url.long_url)
    end

    it 'should give valid created_at for a valid slug' do
      get urls_show_path, params: { slug: @url.slug }
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys!
      expect(json[:created_at]).to_not be_nil
    end

    it 'should respond with 400 if slug is not found' do
      get urls_show_path, params: { slug: '#*asd' } # can never have special characters
      expect(response.status).to eq(400)
      json = JSON.parse(response.body).deep_symbolize_keys!
      expect(json[:message]).to eq('Slug not found')
    end
  end

  describe 'POST /urls/' do
    it 'should return 400 if long_url is empty' do
      long_url = ''
      post urls_create_path, params: { long_url: long_url }
      expect(response.status).to eq(400)
      json = JSON.parse(response.body).deep_symbolize_keys!
      expect(json[:message]).to eq('Not a valid long_url')
    end

    it 'should return valid slug for a valid long_url' do
      long_url = 'https://www.google.com'
      post urls_create_path, params: { long_url: long_url }
      expect(response.status).to eq(200)
      json = JSON.parse(response.body).deep_symbolize_keys!
      expect(json[:long_url]).to eq(long_url)
      expect(json[:slug]).to_not be_nil
    end

    it 'should return the same slug for the same long_url' do
      long_url = 'https://www.google.com'
      post urls_create_path, params: { long_url: long_url }
      expect(response.status).to eq(200)
      json = JSON.parse(response.body).deep_symbolize_keys!
      previous_slug = json[:slug]

      post urls_create_path, params: { long_url: long_url } # Create with same long_url
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys!
      expect(json[:long_url]).to eq(long_url)
      expect(json[:slug]).to eq(previous_slug)
    end

    it 'should return same slug for same long_url with spaces' do
      long_url = 'https://www.google.com'
      post urls_create_path, params: { long_url: long_url }
      expect(response.status).to eq(200)
      json = JSON.parse(response.body).deep_symbolize_keys!
      previous_slug = json[:slug]

      post urls_create_path, params: { long_url: '    ' + long_url + '     ' } # Create with same long_url with spaces
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys!
      expect(json[:long_url]).to eq(long_url)
      expect(json[:slug]).to eq(previous_slug)
    end

    it 'should return 400 if long_url params is not included' do
      post urls_create_path, params: { }
      expect(response.status).to eq(400)
    end
  end
end
