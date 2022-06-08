require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'Validations' do
    subject {
      described_class.new(slug: 'abcde', long_url: 'https://www.google.com')
    }

    it 'should be valid for valid attributes' do
      expect(subject).to be_valid
    end

    it 'should be invalid for slug being empty' do
      subject.slug = nil
      expect(subject).to be_invalid
    end

    it 'should be invalid for long_url being empty' do
      subject.long_url = nil
      expect(subject).to be_invalid
    end

    it 'should be invalid for same slug' do
      subject.save!

      new_url = Url.new(slug: subject.slug, long_url: 'https://www.apple.com')
      expect(new_url).to be_invalid
    end

    it 'should be invalid for same long_url' do
      subject.save!

      new_url = Url.new(slug: 'bnbnb', long_url: subject.long_url)
      expect(new_url).to be_invalid
    end
  end
end
