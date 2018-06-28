class RadioStationsController < ApplicationController
  before_action :set_radio_station, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :edit, :show, :destroy]

  def top
    render 'top'
  end

  def index
  # @radio_stations = RadioStation.order(:updated_at)
 ## render 'index'
  end

  def new
    if params[:back]
      @radio_station = RadioStation.new(radio_station_params)
    else
      @radio_station = RadioStation.new
      @radio_station.user_id = current_user.id
    end
  end

  def confirm
    @radio_station = RadioStation.new(radio_station_params)
    render 'new' if @radio_station.invalid?
  end

  def create
    @radio_station = RadioStation.new(radio_station_params)
    if @radio_station.save
#     redirect_to radio_stations_path, notice: "Radio station was successfully created."
#     redirect_to radio_station_path, notice: "Radio station was successfully created."
      redirect_to root_path, notice: "Radio station was successfully created."
    else
      render 'new'
    end
  end

  def show
  # @favorite = current_user.favorites.find_by(radio_station_id: @radio_station.id)
  end

  def edit
  end

  def update
#   if @radio_station.update(radio_station_params)
#     redirect_to radio_stations_path, notice: "ブログを編集しました！"
  #     format.html { redirect_to @radio_station, notice: 'Radio station was successfully updated.' }
#   else
#     render 'edit'
#   end
  end

  def destroy
  # @radio_station.destroy
#   redirect_to radio_stations_path, notice: "ブログを削除しました！"
  #   format.html { redirect_to radio_stations_url, notice: 'Radio station was successfully destroyed.' }
  end

  private
    def set_radio_station
      @radio_station = RadioStation.find(params[:id])
    end

    def radio_station_params
      params.require(:radio_station).permit(:user_id, \
        :callsign, :city, :branding, :station_format, :webcast_url, :website, :comment)
    end

    def logged_in_user
      redirect_to new_session_path unless logged_in?
    end
end
