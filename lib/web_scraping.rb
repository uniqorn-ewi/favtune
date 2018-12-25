class WebScraping
  WIKIPEDIA_BASE = 'https://en.wikipedia.org/wiki/'

  def self.get_html_docu(url)
    charset = nil
    html = open(url, allow_redirections: :all) do |f|
      charset = f.charset
      f.read
    end
    docu = Nokogiri::HTML.parse(html, nil, charset)
  end

  def self.get_callsigns(state_or_province)
    ary = []

    re_format =
      Regexp.compile(
        "(Oldies|Classic rock|Classic hits)",
         Regexp::IGNORECASE
      )
    re_licensee =
      Regexp.compile(
        "(CC Licenses|Capstar TX|Citicasters|AMFM Broadcasting)",
         Regexp::IGNORECASE
      )

    url =
      WIKIPEDIA_BASE + 'List_of_radio_stations_in_' + state_or_province
    docu = get_html_docu(url)

    docu.xpath('//table[@class="wikitable sortable"]/tbody/tr[position()>1]')
      .each do |element|

      format = element.xpath('.//td[5]').text.gsub(/\n/, '')
      next if !(re_format === format)

      licensee = element.xpath('.//td[4]').text
      next if re_licensee === licensee

      callsign = element.xpath('.//td[1]/a/@href').to_s.gsub(/\/wiki\//, '')
      next if callsign.include?('edit')

      ary << callsign
    end

    ary = ary.uniq
  end

end
