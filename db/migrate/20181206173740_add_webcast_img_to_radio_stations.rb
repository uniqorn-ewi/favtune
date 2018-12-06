class AddWebcastImgToRadioStations < ActiveRecord::Migration[5.1]
  def up
    add_column :radio_stations, :webcast_img, :string
  end

  def down
    remove_column :radio_stations, :webcast_img
  end
end
