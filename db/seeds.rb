require "csv"

CSV.foreach('db/radio_stations.tsv',
            col_sep: "\t",
            quote_char: '"',
            headers: true) do |row|
    RadioStation.create(
      callsign:       row['callsign'],
      city:           row['city'],
      branding:       row['branding'],
      station_format: row['station_format'],
      webcast_url:    row['webcast_url'],
      webcast_img:    row['webcast_img'],
      website:        row['website'],
      comment:        row['comment'],
      user_id:        row['user_id']
    )
end
