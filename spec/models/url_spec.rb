require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'Validations' do
    subject {
      described_class.new(slug: 'abcde', long_url: 'https://www.google.com')
    }

    it 'should be valid for valid attributes' do
      expect(subject).to be_valid
    end

    it 'should be invalid for long_url being empty' do
      subject.long_url = nil
      expect(subject).to be_invalid
    end

    it 'should be invalid for same slug' do
      subject.save!

      new_url = Url.new(long_url: 'https://www.apple.com')
      new_url.save! # autogenerate the slug

      new_url.slug = subject.slug
      expect(new_url).to be_invalid
    end

    it 'should be invalid for same long_url' do
      subject.save!

      new_url = Url.new(slug: 'bnbnb', long_url: subject.long_url)
      expect(new_url).to be_invalid
    end
  end

  describe 'Creation of Url' do
    subject {
      described_class.new(long_url: 'https://www.google.com')
    }

    it 'should generate a slug automatically for a given long_url' do
      subject.save!

      expect(subject.slug).to_not be_empty
    end

    it 'should generate a new unique slug for subsequent long_urls' do
      subject.save!

      new_url = Url.new(long_url: 'https://www.apple.com')
      expect(new_url.save).to be_truthy
      expect(new_url.slug).to_not eq(subject.slug)
    end

    it 'should generate slug with specific length' do
      subject.save!
      expect(subject.slug.length).to eq(Url::SLUG_LENGTH)
    end
  end

  describe 'Find or create url' do
    subject {
      described_class.find_or_create!(long_url: 'https://www.apple.com')
    }

    it 'should return nil if long_url is empty' do
      url = described_class.find_or_create!(long_url: '')
      expect(url).to be_nil
    end

    it 'should return nil if long_url is spaces' do
      url = described_class.find_or_create!(long_url: '   ')
      expect(url).to be_nil
    end

    it 'should create a new url if long_url is new' do
      expect(subject.persisted?).to be_truthy
    end

    it 'should create a new url if long_url is something else' do
      url = described_class.find_or_create!(long_url: 'https://www.google.com')
      expect(url).to_not be_nil
    end

    it 'should return the same url if long_url is same' do
      url = described_class.find_or_create!(long_url: subject.long_url)
      expect(url.slug).to eq(subject.slug)
      expect(url).to eq(subject)
    end
  end
end
