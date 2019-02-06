class RadioStation < ApplicationRecord
  validates(
    :callsign,
    presence: true,
    length: { maximum: 20 },
    format: { with: /\A[C|K|V|W]{1}[A-Z]{2,3}[_|\-]?[(]?([A-Za-z_]+)?[)]?\z/ },
    uniqueness: { case_sensitive: true }
  )
  validates(
    :webcast_url,
    presence: true,
    length: { maximum: 255 },
    format: /\A#{URI::regexp(%w(http https))}\z/,
    uniqueness: { case_sensitive: false }
  )
  validates(
    :website,
    presence: true,
    length: { maximum: 255 },
    format: /\A#{URI::regexp(%w(http https))}\z/
  )
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
end
