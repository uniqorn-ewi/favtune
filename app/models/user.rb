class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: :false }
  before_save { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  has_many :radio_stations
# has_many :favorites, -> { order(:id) }, dependent: :destroy
# has_many :favorite_stations, through: :favorites, source: :radio_station
# mount_uploader :avatar, AvatarUploader
end
