require 'csv'

path_csv = "db/invalid_radio_stations.csv"
CSV.foreach(path_csv, headers: true) do |row|
  c = Callsign.find_by(spelling: row['spelling'])
  c.update(isvalid: false)
end

path_tsv = "db/radio_stations.tsv"
CSV.foreach(path_tsv, col_sep: "\t", quote_char: '"', headers: true) do |row|
  c = Callsign.find_by(spelling: row['callsign'])
  c.update(isvalid: true)

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
