begin
  require_relative './transaction.rb'
end

# Valid shipment transactions
class ValidTransaction < Transaction
  attr_accessor :date, :package, :provider

  def initialize(raw_string, date, package, provider)
    super(raw_string)

    @date = date
    @package = package
    @provider = provider
  end

  def self.parse(raw_string, metadata_factory = MetadataFactory::Instance)
    parts = raw_string.split(' ')
    ValidTransaction.new(
      raw_string,
      Date.parse(parts[0]),
      metadata_factory.find_package_by_size(parts[1]),
      metadata_factory.find_provider_by_short_name(parts[2])
    )
  end

  def to_s
    "#{@date} #{@package} #{@provider}"
  end
end
