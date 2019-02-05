class DeleteRadioStationService
  include Service

  def initialize(radio_station)
    @radio_station = radio_station
  end

  private
  attr_reader :radio_station

  def call
    Callsign.transaction do
      callsign =
        Callsign.lock.find_by(spelling: @radio_station.callsign)
      callsign.update!(isvalid: nil)
    end
    @radio_station.destroy
  end
end
