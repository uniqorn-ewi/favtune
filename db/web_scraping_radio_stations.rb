require 'csv'

user_id ='1'
headers =
  ["callsign","city","branding","station_format",
   "webcast_url","webcast_img","website","comment","user_id"]
columns = nil

path_csv = "db/invalid_radio_stations.csv"
path_tsv = "db/radio_stations.tsv"

CSV.open(path_tsv, "w", col_sep: "\t", force_quotes: true) do |tsv|
  f_csv = File.open(path_csv, "w")
  f_csv.puts "spelling"

  tsv << headers

  callsigns = Callsign.select("spelling").order(:id)
  callsigns.each do | callsign |
    info = WebScraping.get_station_info(callsign.spelling)

    if info[:isvalid].nil?
      next
    elsif info[:isvalid]
      comment = info[:comment]
      comment = comment.tr("#", "\n") unless comment.nil?
      columns = [
        info[:callsign], info[:city], info[:branding], info[:station_format],
        info[:webcast_url], info[:webcast_img], info[:website_url],
        comment, user_id
      ]
      tsv << columns
    else
      f_csv.puts "#{callsign.spelling}"
    end

    sleep 0.5
  end

  f_csv.close
end # close path_tsv
