class RadioStation < ApplicationRecord
  validates :callsign,  presence: true, length: { maximum: 7 },
                    format: { with: /\A([A-Z]|[A-Z]{2})[A-Z]{1,3}[\-]?[A-Z0-9]{0,3}\z/ },
                    uniqueness: { case_sensitive: :false }
  validates :webcast_url, presence: true, length: { maximum: 255 },
                    format: /\A#{URI::regexp(%w(http https))}\z/,
                    uniqueness: { case_sensitive: :false }
  belongs_to :user
# has_many :favorites, dependent: :destroy
# has_many :favorite_users, through: :favorites, source: :user
end
