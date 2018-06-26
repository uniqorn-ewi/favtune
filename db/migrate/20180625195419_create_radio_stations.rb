class CreateRadioStations < ActiveRecord::Migration[5.1]
  def change
    create_table :radio_stations do |t|
      t.string :callsign
      t.string :city
      t.string :branding
      t.string :station_format
      t.string :webcast_url
      t.string :website
      t.string :comment
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
