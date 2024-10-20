# This url class creates an association between the Url model and the Visit model. The Url model has many visits, and when a Url is destroyed, all of its associated visits are destroyed as well. This is a good example of how to use
class Url < ApplicationRecord
  # each url is associated with many Visit object, if the url is destroyed, all of its associated visits are destroyed
  has_many :visits, dependent: :destroy

  validates :original_url, presence: true
  validate :validate_original_url_format

  validates :short_url, presence: true, uniqueness: true
  validates :title, presence: true

  private

  def validate_original_url_format
    begin
      uri = URI.parse(original_url)
      unless uri.is_a?(URI::HTTP) && uri.host.present?
        errors.add(:original_url, "does not match the required http/https format")
      end
    rescue URI::InvalidURIError
      errors.add(:original_url, "is not a valid URL")
    end
  end
end
