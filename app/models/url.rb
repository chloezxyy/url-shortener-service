# This url class creates an association between the Url model and the Visit model. The Url model has many visits, and when a Url is destroyed, all of its associated visits are destroyed as well. This is a good example of how to use
class Url < ApplicationRecord
  # each url is associated with many Visit object, if the url is destroyed, all of its associated visits are destroyed
  has_many :visits, dependent: :destroy

  # validates the presence of the original_url and the format of the original_url
  validates :original_url, presence: true, format: { with: URI.regexp(%w[http https]) }
  validates :short_url, presence: true, uniqueness: true
  validates :title, presence: true
end
