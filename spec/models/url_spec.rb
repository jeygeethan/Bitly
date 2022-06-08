require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'Validations' do
    subject {
      described_class.new(slug: 'abcde', long_url: 'https://www.google.com')
    }
    it 'should be valid for valid attributes' do
      expect(subject).to be_valid
    end
  end
end
