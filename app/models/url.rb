# Model to contain the shortened slugs for long urls
class Url < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :long_url, presence: true, uniqueness: true
end
