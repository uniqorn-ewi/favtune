module RadioStationsHelper
  def choose_new_or_edit
    if action_name == 'new' || action_name == 'confirm'
      confirm_radio_stations_path
    elsif action_name == 'edit'
      radio_station_path
    end
  end
end
