class DataSaver
  def initialize(logger:)
    @logger = logger
  end

  def save_to_file(product_infos, file_name)
    CSV.open(file_name, 'wb') do |csv|
      csv << ["Name", "Image URL", "Price"]

      product_infos.each.with_index(1) do |product_info, product_number|
        logger.info "Write down information about the product number #{product_number} to the file #{file_name}"
        csv << [product_info.fetch(:name), product_info.fetch(:image_url), product_info.fetch(:price)]
      end
    end
  end

  attr_reader :logger
end
