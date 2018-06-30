class FavoriteStationsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @favorite_stations = @user.favorite_stations
  end
end
