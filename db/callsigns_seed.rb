require 'csv'

path = "db/callsigns.csv"
CSV.foreach(path, headers: true) do |row|
  if Callsign.find_by(spelling: row['spelling']).nil?
    Callsign.create(
      spelling: row['spelling'], province_id: row['province_id']
    )
  end
end
