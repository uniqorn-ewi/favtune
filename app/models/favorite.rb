class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :radio_station
end
