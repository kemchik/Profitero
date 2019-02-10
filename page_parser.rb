class PageParser
  def parse(page_url)
    http = Curl.get(page_url)
    page_dom = http.body_str
    Nokogiri::HTML(page_dom)
  end
end
