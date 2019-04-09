class User < ApplicationRecord
  attr_accessor :activation_token
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 30 }
  validates(
    :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }
  )
  before_save { email.downcase! }
  has_secure_password
  validates(
    :password,
    presence: true,
    length: { minimum: 6 },
    allow_nil: true
  )
  has_many :radio_stations, dependent: :destroy
  has_many :favorites, -> { order(:id) }, dependent: :destroy
  has_many :favorite_stations, through: :favorites, source: :radio_station

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
