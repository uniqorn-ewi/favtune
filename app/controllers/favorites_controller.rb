class FavoritesController < ApplicationController
# before_action :logged_in_user, only: [:destroy]

  def create
    favorite = current_user.favorites.create(radio_station_id: params[:id])
    redirect_to radio_stations_path, notice: "Favorite radio station info was successfully created."
  end

  def destroy
  # if @radio_station.user_id.eql?(current_user.id)
    favorite = current_user.favorites.find_by(radio_station_id: params[:id]).destroy
    redirect_to radio_stations_path, notice: "Favorite radio station info was successfully destroyed."
  # else
  #   redirect_to root_path, notice: "Invalid User!"
  # end
  end

# private
#   def logged_in_user
#     redirect_to new_session_path unless logged_in?
#   end
end
