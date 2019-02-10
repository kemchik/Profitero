require 'nokogiri'
require 'csv'
require 'curb'

require_relative 'parser_logger'
require_relative 'page_parser'
require_relative 'category_page_parser'
require_relative 'data_save'

puts "Enter category url"
category_page_url = gets.chomp.strip.to_s

puts "Enter file name to save"
file_name = "#{gets.chop.to_s}.csv"

logger = ParserLogger.new
page_parser = PageParser.new
category_page_parser = CategoryPageParser.new(page_parser: page_parser, logger: logger)
product_infos = category_page_parser.parse(category_page_url)

data_saver = DataSaver.new(logger: logger)
data_saver.save_to_file(product_infos, file_name)

puts "The end"



