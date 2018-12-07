

headers =
  ['"callsign"','"city"','"branding"','"station_format"',
   '"webcast_url"','"webcast_img"','"website"','"comment"','"user_id"']
headers = headers.join("\t")


columns = []
File.open("db/radio_stations.tsv", "w") do |f|
  f.puts "#{headers}"

  columns =
    ['"KAMP-FM"','"CBS Radio East"','"LLC"','"Classic rock"',
     '"http://player.radio.com/listen/station/channel-q"',
     '""',
     '"http://amp.radio.com"',
     '""',
     '"1"']
  columns = columns.join("\t")
  columns = columns.tr("#", "\n")
  f.puts "#{columns}"

  columns =
    ['"KFXM-LP"','"reservation"','"Cultivation of Radio"','"Oldies"',
     '"http://www.nwrnetwork.com/listen/player.asp?station=kfxm-fm"',
     '"http://www.christiannetcast.com/images/christiannetcast_400.png"',
     '"http://www.kfxm.com/"',
     '"KFXM-LP Webstream URL#http://ic1.nwrnetwork.com/kfxm-fm.m3u"',
     '"1"']
  columns = columns.join("\t")
  columns = columns.tr("#", "\n")
  f.puts "#{columns}"

  columns =
    ['"KBOV"','"Great Country"','"Inc"','"Oldies"',
     '"http://www.mainstreamnetwork.com/listen/player.asp?station=kibs-fm"',
     '"http://www.mainstreamnetwork.com/images/mainstreamnetwork_200.jpg"',
     '"http://www.kibskbov.com"',
     '""',
     '"1"']
  columns = columns.join("\t")
  columns = columns.tr("#", "\n")
  f.puts "#{columns}"
end
