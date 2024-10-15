# This url class creates an association between the Url model and the Visit model. The Url model has many visits, and when a Url is destroyed, all of its associated visits are destroyed as well. This is a good example of how to use
class Url < ApplicationRecord
  # each url is associated with many Visit object, if the url is destroyed, all of its associated visits are destroyed
  has_many :visits, dependent: :destroy

  # validates the presence of the original_url and the format of the original_url
  validates :original_url, presence: true, format: { with: URI.regexp(%w[http https]) }
  validates :short_url, presence: true, uniqueness: true
  validates :title, presence: true

  # should save the url after generating the short url
  before_create :generate_short_url

  private

  def generate_short_url
    base_url = ""

    # TODO deploy
    if Rails.env.production?
      base_url = "https://shorten-url.herokuapp.com"
    else
      base_url = "http://localhost:3000"
    end

    self.short_url = "#{base_url}/#{self.short_url}"
  end
end
