class RadioStation < ApplicationRecord
  validates :callsign,  presence: true, length: { maximum: 7 },
                    uniqueness: { case_sensitive: :false }
                  # format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
  validates :webcast_url, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: :false }
                  # format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
  belongs_to :user
# has_many :favorites, dependent: :destroy
# has_many :favorite_users, through: :favorites, source: :user
end
