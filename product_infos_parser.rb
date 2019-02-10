class ProductInfosParser
  ALL_LI_WITH_WEIGHT_SELECTOR = "//ul[@class='attribute_radio_list']/li"
  H1_PRODUCT_NAME_SELECTOR = "//h1[@class='product_main_name']/text()"
  SRS_ON_IMAGE_SELECTOR = "//img[@id='bigpic']/@src"
  ALL_PRODUCT_PRICES_SELECTOR = "//span[@class='price_comb']"
  ALL_PRODUCT_WEIGHT_SELECTOR = "//span[@class='radio_label']/text()"

  def initialize(page_parser:, logger:)
    @page_parser = page_parser
    @logger = logger
  end

  def parse(product_url)
    product_page = page_parser.parse(product_url)
    get_product_infos(product_page)
  end

  def get_product_infos(page)
    products = []
    number_of_weights = page.xpath(ALL_LI_WITH_WEIGHT_SELECTOR).size
    product_name = page.xpath(H1_PRODUCT_NAME_SELECTOR).text.strip
    image_link = page.xpath(SRS_ON_IMAGE_SELECTOR).text.strip.to_s

    data = get_each_weight_and_price(page, number_of_weights)
    data.each do |item|
      products.push(
          name: "#{product_name} - #{item[:weight]}",
          price: item[:price],
          image_url: image_link,
          )
    end

    products
  end

  def get_each_weight_and_price(page, number_of_weights)
    weight_and_prices = []
    number_of_weights.times do |number|
      product_weight = page.xpath(ALL_PRODUCT_WEIGHT_SELECTOR)[number].text.strip
      product_price = page.xpath(ALL_PRODUCT_PRICES_SELECTOR)[number].text.strip
      weight = " #{product_weight} "
      weight_and_prices.push(
          weight: weight,
          price: product_price,
          )
    end

    weight_and_prices
  end

  private

  attr_reader :page_parser, :logger
end
