require_relative 'product_infos_parser'

class ProductsPageParser
  ALL_LI_IN_PRODUCT_LIST_SELECTOR = "//ul[@id='product_list']//li"
  ALL_HREFS_ON_PRODUCT_SELECTOR = "//a[@class='product-name']/@href"


  def initialize(page_parser:, logger:)
    page_parser = page_parser
    @logger = logger
    @product_infos_parser = ProductInfosParser.new(page_parser: page_parser, logger: logger)
  end

  def parse(page)
    product_infos_array = []
    number_of_products = page.xpath(ALL_LI_IN_PRODUCT_LIST_SELECTOR).size
    number_of_products.times do |product_index|
      link_to_product = page.xpath(ALL_HREFS_ON_PRODUCT_SELECTOR)[product_index].to_s
      logger.info "Parse product number #{product_index + 1}"
      product_infos = product_infos_parser.parse(link_to_product)
      product_infos_array.push(product_infos)
    end

    product_infos_array.flatten
  end

  private

  attr_reader :logger, :product_infos_parser
end
