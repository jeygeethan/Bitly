# Model to contain the shortened slugs for long urls
class Url < ApplicationRecord
  SLUG_LENGTH = 5

  validates :slug, presence: true, uniqueness: true
  validates :long_url, presence: true, uniqueness: true

  before_validation :generate_slug, if: :new_record?

  def self.find_or_create!(long_url: '')
    long_url.strip!
    return nil if long_url.blank?

    url = Url.where(long_url: long_url.strip).first
    return url if url.present?

    Url.create!(long_url: long_url.strip)
  end

  private

  def generate_slug
    self.slug = random_slug_string
  end

  def random_slug_string
    [*'a'..'z', *0..9, *'A'..'Z'].shuffle[0...SLUG_LENGTH].join
  end
end
