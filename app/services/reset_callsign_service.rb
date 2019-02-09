class ResetCallsignService
  include Service

  def initialize(user)
    @user = user
  end

  private
  attr_reader :user

  def call
    radio_stations = @user.radio_stations.select(%(id, callsign))
    radio_stations.each do |rs|
      Callsign.transaction do
        cs = Callsign.lock.find_by(spelling: rs.callsign)
        cs.update!(isvalid: nil)
      end
    end
  end
end
