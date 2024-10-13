# This url class creates an association between the Url model and the Visit model. The Url model has many visits, and when a Url is destroyed, all of its associated visits are destroyed as well. This is a good example of how to use
class Url < ApplicationRecord
  # each url is associated with many Visit object, if the url is destroyed, all of its associated visits are destroyed
  has_many :visits, dependent: :destroy

  # validates the presence of the original_url and the format of the original_url
  validates :original_url, presence: true, format: URI.regexp(%w[http https])
  validates :short_url, presence: true, uniqueness: true,  length: { maximum: 15 }

  # before saving the url, generate a short url and fetch the title of the page
  before_save :generate_short_url, :fetch_title

  private

  # generate a random short url
  def generate_short_url
    # Generate a unique identifier
    unique_id = SecureRandom.random_number(1_000_000)
    # Convert the unique identifier to a base62 string
    self.short_url = Base62.encode(unique_id)
  end

  # fetch the title of the page
  def fetch_title
    response = HTTParty.get(self.original_url)
    self.title = Nokogiri::HTML(response.body).title if response.success?
  rescue
    self.title = "Unknown Title"
  end
end
