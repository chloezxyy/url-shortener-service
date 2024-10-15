class Visit < ApplicationRecord
  belongs_to :url

  validates :ip_address, presence: true
  validates :geolocation, presence: true
end
