require_relative 'products_page_parser'

class CategoryPageParser
  ALL_PAGINATION_BOTTOMS_SPANS_SELECTOR = "//*[@id='pagination_bottom']/ul/li/a/span"
  NUMBER_OF_PAGES_SPAN_INDEX = -2

  def initialize(page_parser:, logger:)
    @product_page_parser = ProductsPageParser.new(page_parser: page_parser, logger: logger)
    @page_parser = page_parser
    @logger = logger
  end

  def parse(category_page_url)
    logger.info "Start to parse category page"
    start_category_page = page_parser.parse(category_page_url)
    number_of_pages = get_number_of_pages(start_category_page)
    product_infos_array = []

    for page_number in 1..number_of_pages
      logger.info "Start to load page number #{page_number}"
      page_by_number = page_parser.parse("#{category_page_url}?p=#{page_number}")
      product_infos = product_page_parser.parse(page_by_number)
      product_infos_array.push(product_infos)
    end

    logger.info "Finish to parse category page!"
    product_infos_array.flatten
  end

  private

  def get_number_of_pages(start_page)
    page_spans = start_page.xpath(ALL_PAGINATION_BOTTOMS_SPANS_SELECTOR)
    page_spans[NUMBER_OF_PAGES_SPAN_INDEX].text.to_i
  end

  attr_reader :product_page_parser, :page_parser, :logger
end
