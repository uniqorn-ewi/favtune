class RadioStationsController < ApplicationController
# before_action :set_radio_station, only: [:show, :edit, :update, :destroy]

  def top
    render 'top'
  end

  # GET /radio_stations
  def index
  # @radio_stations = RadioStation.all
  end

  # GET /radio_stations/1
  def show
  end

  # GET /radio_stations/new
  def new
  # @radio_station = RadioStation.new
  end

  # GET /radio_stations/1/edit
  def edit
  end

  def confirm
  # @picture = Picture.new(picture_params)
  # render 'new' if @picture.invalid?
  end

  # POST /radio_stations
  def create
  # @radio_station = RadioStation.new(radio_station_params)
  # 
  # respond_to do |format|
  #   if @radio_station.save
  #     format.html { redirect_to @radio_station, notice: 'Radio station was successfully created.' }
  #     format.json { render :show, status: :created, location: @radio_station }
  #   else
  #     format.html { render :new }
  #     format.json { render json: @radio_station.errors, status: :unprocessable_entity }
  #   end
  # end
  end

  # PATCH/PUT /radio_stations/1
  def update
  # respond_to do |format|
  #   if @radio_station.update(radio_station_params)
  #     format.html { redirect_to @radio_station, notice: 'Radio station was successfully updated.' }
  #     format.json { render :show, status: :ok, location: @radio_station }
  #   else
  #     format.html { render :edit }
  #     format.json { render json: @radio_station.errors, status: :unprocessable_entity }
  #   end
  # end
  end

  # DELETE /radio_stations/1
  def destroy
  # @radio_station.destroy
  # respond_to do |format|
  #   format.html { redirect_to radio_stations_url, notice: 'Radio station was successfully destroyed.' }
  #   format.json { head :no_content }
  # end
  end

# private
#   # Use callbacks to share common setup or constraints between actions.
#   def set_radio_station
#     @radio_station = RadioStation.find(params[:id])
#   end
#
#   # Never trust parameters from the scary internet, only allow the white list through.
#   def radio_station_params
#     params.fetch(:radio_station, {})
#   end
end
