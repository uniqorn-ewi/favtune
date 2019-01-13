require 'json'
require 'net/http'
require 'net/protocol'
require 'open-uri'
require 'openssl'
require 'socket'
require 'timeout'
require 'uri'

class WebScraping
  UA_WIKI = "Mozilla/5.0 (WebAPIClient; Ruby)"
  UA_SITE = "Mozilla/5.0 (X11; Linux x86_64) \
    AppleWebKit/xxxxxx (KHTML, like Gecko) Chrome/xxxxxx Safari/xxxxx"

  WIKIPEDIA_BASE = "https://en.wikipedia.org/wiki/"

  WIKIPEDIA_API =
    "https://en.wikipedia.org/w/api.php?action=parse&format=json&page="

  RE_FORMAT =
    Regexp.compile(
      "(Oldies|Classic rock|Classic hits)",
       Regexp::IGNORECASE
    )
  RE_LICENSEE =
    Regexp.compile(
      "(CC Licenses|Capstar TX|Citicasters|AMFM Broadcasting)",
       Regexp::IGNORECASE
    )

  RE_STREAM_URL1 = Regexp.compile("(\.pls|\.m3u|\.asx)")
  RE_STREAM_URL2 =
    Regexp.compile("http(s)?:\/\/([\\w-]+\\.)+[\\w-]+(:[0-9]+)+(\/)?")

  RE_FORBIDDEN_URL1 = Regexp.compile("http(s)?:\/\/www.iheart.com")
  RE_FORBIDDEN_URL2 = Regexp.compile("http(s)?:\/\/player.radio.com")
  RE_FORBIDDEN_URL3 =
    Regexp.compile("http(s)?:\/\/streamdb1web.securenetsystems.net")
  RE_FORBIDDEN_URL4 =
    Regexp.compile("http(s)?:\/\/streamdb2web.securenetsystems.net")

  RE_POPUP =
    Regexp.compile("\\Ahttp(s)?:\/\/([\\w-]+\\.)+([\\w-]+\/)+popup\\z")

  RE_LISTEN_LIVE =
    Regexp.compile("Listen[ |\-]?Live", Regexp::IGNORECASE)
  RE_URI =
    Regexp.compile("\\A#{URI::regexp(%w(http https))}\\z", Regexp::IGNORECASE)

  RE_URL1 = Regexp.compile("http(s)?:\/\/v5.player.abacast.com")
  RE_URL2 = Regexp.compile("http(s)?:\/\/player.streamtheworld.com")
  RE_URL3 = Regexp.compile("http(s)?:\/\/player.radioloyalty.com")
  RE_URL4 = Regexp.compile("http(s)?:\/\/globecasting.us:8000/")
  RE_URL5 = Regexp.compile("http(s)?:\/\/freestreams.alldigital.net:8000/")
  RE_URL6 = Regexp.compile("http(s)?:\/\/player.fullviewplayer.com/")
  RE_URL7 = Regexp.compile("http(s)?:\/\/ca3.radioboss.fm/proxy/")
  RE_URL8 = Regexp.compile("http(s)?:\/\/cjuv.streamon.fm/")
  RE_URL9 = Regexp.compile("http(s)?:\/\/ice6.securenetsystems.net/")

  def self.get_html_docu(url)
    begin
      charset = nil

      opt = {}
      opt["User-Agent"] = UA_SITE
      opt[:allow_redirections] = :all

      html = open(url, opt) do |f|
        charset = f.charset
        f.read
      end

      docu = Nokogiri::HTML.parse(html, nil, charset)

    rescue OpenURI::HTTPError # Such as 403:Forbidden
      docu = nil
    rescue Net::OpenTimeout
      docu = nil
    rescue Net::ReadTimeout
      docu = nil
    rescue RuntimeError
      docu = nil
    rescue => e
      raise e
    end

    return docu
  end

  def self.get_callsigns(state_or_province)
    ary = []

    url =
      WIKIPEDIA_BASE + 'List_of_radio_stations_in_' + state_or_province
    docu = get_html_docu(url)

    docu.xpath('//table[@class="wikitable sortable"]/tbody/tr[position()>1]')
      .each do |element|

      format = element.xpath('.//td[5]').text.gsub(/\n/, '')
      next if !(RE_FORMAT === format)

      licensee = element.xpath('.//td[4]').text
      next if RE_LICENSEE === licensee

      callsign = element.xpath('.//td[1]/a/@href').to_s.gsub(/\/wiki\//, '')
      next if callsign.include?('edit')

      ary << callsign
    end

    return ary.uniq
  end

  def self.open_wiki(uri)
    session = Net::HTTP.new(uri.host, uri.port)
    session.open_timeout = 50
    session.read_timeout = 50
    session.use_ssl = true
    session.verify_mode = OpenSSL::SSL::VERIFY_NONE

    opt = {}
    opt["User-Agent"] = UA_WIKI
    req = Net::HTTP::Get.new(uri.request_uri, opt)

    begin
      res = session.start {|ss| ss.request(req) }

      case res
      when Net::HTTPSuccess
        docu = JSON.parse(res.body)['parse']['text']['*']
      else
      end

    rescue IOError
      docu = nil
    rescue Timeout::Error
      docu = nil
    rescue JSON::ParserError
      docu = nil
    rescue => e
      raise e
    end

    return docu
  end

  def self.check_forbidden_url?(webcast)
    if RE_FORBIDDEN_URL1 === webcast || RE_FORBIDDEN_URL2 === webcast ||
      RE_FORBIDDEN_URL3 === webcast || RE_FORBIDDEN_URL4 === webcast
      return true
    end
    return false
  end

  def self.check_stream_url?(webcast)
    if RE_STREAM_URL1 === webcast || RE_STREAM_URL2 === webcast
      return true
    end
    return false
  end

  def self.check_url?(webcast)
    if RE_URL1 === webcast || RE_URL2 === webcast ||
      RE_URL3 === webcast || RE_URL4 === webcast ||
      RE_URL5 === webcast || RE_URL6 === webcast ||
      RE_URL7 === webcast || RE_URL8 === webcast ||
      RE_URL9 === webcast
      return true
    end
    return false
  end

  def self.check_access_err?(url, limit = 10)
    raise ArgumentError, "HTTP redirect too deep" if limit == 0
    url = url + '/' if RE_POPUP === url

    u = URI.parse(url)
    param = {
      scheme: u.scheme, host: u.host, port: u.port,
      path: u.path, query: u.query
    }

    begin
      uri = URI::HTTP.build(param)
      session = Net::HTTP.new(uri.host, uri.port)
      session.open_timeout = 5
      session.read_timeout = 5

      if uri.scheme.eql?('https') || uri.port == 443
        session.use_ssl = true
        session.verify_mode = OpenSSL::SSL::VERIFY_NONE

        cert = session.start {|ss| ss.peer_cert }
        diff = cert.not_after.gmtime - Time.now.gmtime
        if diff <= 0.0
          raise OpenSSL::X509::CertificateError, "Expired!"
        end
      end

      opt = {}
      opt["User-Agent"] = UA_SITE
      req = Net::HTTP::Get.new(uri.request_uri, opt)
      res = session.start {|ss| ss.request(req) }

      case res
      when Net::HTTPSuccess
        check = false
      when Net::HTTPRedirection
        if url.include?("https://tunein.com/radio/")
          location = "https://tunein.com" + res['location']
          check_access_err?(location, limit - 1)
        else
          check_access_err?(res['location'], limit - 1)
        end
        check = false
      else
        check = true
      end

    rescue URI::InvalidComponentError
      check = true
    rescue SocketError              #Server Not Found
      check = true
    rescue Net::OpenTimeout
      check = true
    rescue Net::ReadTimeout
      check = true
    rescue Net::HTTPError           #HTTP code:1xx
      check = true
    rescue Net::HTTPServerException #HTTP code:4xx
      check = true
    rescue Net::HTTPFatalError      #HTTP code:5xx
      check = true
    rescue Errno::ECONNREFUSED
      check = true
    rescue Timeout::Error
      check = true
    rescue EOFError
      check = true
    rescue OpenSSL::X509::CertificateError
      check = true
    rescue ArgumentError
      check = true
    rescue => e
      raise e
    end

    return check
  end

  def self.get_webcast_url(website_url)
    webcast_url = nil

    docu = get_html_docu(website_url)

    if !docu.nil?
      docu.xpath('//a').each do |element|
        href = element.xpath('@href').to_s
        if RE_LISTEN_LIVE === element.text &&
          RE_URI === href && !check_forbidden_url?(href)
          webcast_url = href
          break
        end
      end
    end

    return webcast_url
  end

  def self.get_webcast_img(webcast_url)
    img_docu = get_html_docu(webcast_url)
    return nil if img_docu.nil?

    docu_head = img_docu.xpath('/html/head')
    if docu_head.empty?
      iframe_src = img_docu.xpath('//iframe/@src')
      return nil if iframe_src.empty?

      img_docu = get_html_docu(iframe_src.to_s)
      return nil if img_docu.nil?
    end

    og_image =
      img_docu.xpath('/html/head/meta[@property="og:image"]/@content')
    return nil if og_image.empty?

    return og_image.to_s
  end

  def self.get_station_info(callsign)
    return nil if callsign.nil? || callsign.empty?

    bad_station_info = {isvalid: false}

    uri = URI.parse(WIKIPEDIA_API + "#{callsign}")
    ref = open_wiki(uri)
    return bad_station_info if ref.nil?

    ref = ref.gsub("<br />", ", ")
    docu = Nokogiri::HTML.parse(ref, nil, "UTF-8")

    city, branding, station_format = nil, nil, nil
    webcast_ary, website_ary = [], []
    docu.xpath('//table[@class="infobox vcard"]/tbody/tr[position()>1]')
      .each do |element|
      case element.xpath('.//th').text
      when "City"
        city = element.xpath('.//td').text
      when "Branding"
        branding = element.xpath('.//td').text
      when "Format"
        station_format = element.xpath('.//td').text
      when "Webcast"
        context_node = element.xpath('.//td')
        context_node.xpath('.//a[position()>0]').each do |a|
          webcast_ary << a.xpath('.//@href').to_s
        end
      when "Website"
        context_node = element.xpath('.//td')
        context_node.xpath('.//a[position()>0]').each do |a|
          website_ary << a.xpath('.//@href').to_s
        end
      else
      end
    end

    if !(RE_FORMAT === station_format) || website_ary.size == 0
      return bad_station_info
    end

    website_url = website_ary.first
    return bad_station_info if check_access_err?(website_url)

    webcast_url = nil
    comment = "Stream URL for App like iTunes"

    case webcast_ary.size
    when 0
      webcast_url = get_webcast_url(website_url)
    when 1
      if !check_stream_url?(webcast_ary.first) &&
        !check_forbidden_url?(webcast_ary.first)
        webcast_url = webcast_ary.first
      end
    else
      webcast_ary.each do |webcast|
        if check_forbidden_url?(webcast)
          next
        elsif check_stream_url?(webcast)
          comment = comment + '#' + webcast
        else
          webcast_url = webcast
          break
        end
      end
    end

    webcast_img = nil
    skip_station_info = {isvalid: nil}

    if webcast_url.nil?
      return skip_station_info
    else
      if check_forbidden_url?(webcast_url)
        return bad_station_info
      elsif check_url?(webcast_url) || check_access_err?(webcast_url)
        return skip_station_info
      else
        webcast_img = get_webcast_img(webcast_url)
      end
    end

    good_station_info = {
      isvalid: true,
      callsign: callsign,
      city: city,
      branding: branding,
      station_format: station_format,
      webcast_url: webcast_url,
      webcast_img: webcast_img,
      website_url: website_url,
    }
    good_station_info[:comment] = check_stream_url?(comment) ? comment : nil

    return good_station_info
  end
end
