class CreateRadioStationService
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
      callsign.update!(isvalid: true)
    end
    if @radio_station.save
      true
    else
      false
    end
  end
end
