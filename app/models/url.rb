# Model to contain the shortened slugs for long urls
class Url < ApplicationRecord
  SLUG_LENGTH = 5

  validates :slug, presence: true, uniqueness: true
  validates :long_url, presence: true, uniqueness: true

  before_validation :generate_slug, if: :new_record?

  def self.find_or_create!(long_url: '')
    long_url.strip!
    return nil if long_url.blank?

    url = Url.where(long_url: long_url).first
    return url if url.present?

    Url.create!(long_url: long_url)
  end

  def to_api
    {
      long_url: long_url,
      slug: slug,
      created_at: created_at
    }
  end

  private

  def generate_slug
    random_slug = self.class.random_slug_string
    while Url.where(slug: random_slug).present?
      random_slug = self.class.random_slug_string
    end
    self.slug = random_slug
  end

  def self.random_slug_string
    [*'a'..'z', *0..9, *'A'..'Z'].shuffle[0...SLUG_LENGTH].join
  end
end
