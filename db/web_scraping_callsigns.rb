path = "db/callsigns.csv"

File.open(path, "w") do |f|
  f.puts "spelling,province_id"

  provinces = Province.order(:id)
  provinces.each do | province |
    callsigns = WebScraping.get_callsigns(province.name)

    callsigns.each do | callsign |
      f.puts "#{callsign},#{province.id}"
    end
  end
end
