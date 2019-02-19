class RadioStationsController < ApplicationController
  before_action :set_radio_station, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: %i[ new edit show destroy ]
  before_action :user_has_radio_station, only: %i[ edit destroy ]

  def top
    @radio_station =
      RadioStation.select(%(id, webcast_url)).order(:updated_at).last
  end

  def index
    @radio_stations =
      RadioStation.order(:updated_at).page(params[:page]).per(30)
  end

  def new
    if params[:back]
      @radio_station = RadioStation.new(radio_station_params)
    else
      @radio_station = current_user.radio_stations.build
    end
  end

  def confirm
    @radio_station = RadioStation.new(radio_station_params)
    render :new if @radio_station.invalid?
  end

  def create
    @radio_station = RadioStation.new(radio_station_params)

    if WebScraping.invalid_website?(@radio_station.website)
      flash.now[:danger] = "Invalid web site!"
      render :new
    elsif WebScraping.invalid_webcast?(@radio_station.webcast_url)
      flash.now[:danger] = "Invalid webcast url!"
      render :new
    else
      @radio_station.webcast_img =
        WebScraping.get_webcast_img(@radio_station.webcast_url)
      if CreateRadioStationService.call(@radio_station)
        redirect_to(
          root_path,
          notice: "Radio station info was successfully created."
        )
      else
        render :new
      end
    end
  end

  def show
    @favorite =
      current_user.favorites.find_by(radio_station_id: @radio_station.id)
  end

  def edit
  end

  def update
    edit_params = radio_station_params.to_h

    if WebScraping.invalid_website?(edit_params[:website])
      flash.now[:danger] = "Invalid web site!"
      render :edit
    elsif WebScraping.invalid_webcast?(edit_params[:webcast_url])
      flash.now[:danger] = "Invalid webcast url!"
      render :edit
    else
      edit_params[:webcast_img] =
        WebScraping.get_webcast_img(edit_params[:webcast_url])
      if @radio_station.update(edit_params)
        redirect_to(
          radio_stations_path,
          notice: "Radio station info was successfully updated."
        )
      else
        render :edit
      end
    end
  end

  def destroy
    DeleteRadioStationService.call(@radio_station)
    redirect_to(
      radio_stations_path,
      notice: "Radio station info was successfully destroyed."
    )
  end

  private
    def set_radio_station
      @radio_station = RadioStation.find(params[:id])
    end

    def radio_station_params
      params.require(:radio_station).
        permit(
          :user_id,
          :callsign,
          :city,
          :branding,
          :station_format,
          :webcast_url,
          :website,
          :comment
        )
    end

    def logged_in_user
      redirect_to new_session_path unless logged_in?
    end

    def user_has_radio_station
      if current_user.radio_stations.find_by(
        user_id: @radio_station.user_id
      ).nil?
        redirect_to root_path, notice: "Invalid User!"
      end
    end
end
