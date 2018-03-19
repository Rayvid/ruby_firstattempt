begin
  require_relative '../model/package.rb'
  require_relative '../model/provider.rb'
end

# Its to central gateway for all metadata required to bussiness logic to function
class MetadataFactory
  # Hardcoded for example purposes, but it can be configs/database based
  Package::S = Package.new :S, 'Small sized package'
  Package::M = Package.new :M, 'Medium sized package'
  Package::L = Package.new :L, 'Large package'

  Provider::MR = Provider.new(
    'Mondial Relay',
    :MR,
    Package::S => 2.0, Package::M => 3.0, Package::L => 4.0
  )
  Provider::LP = Provider.new(
    'La Poste',
    :LP,
    Package::S => 1.50, Package::M => 4.90, Package::L => 6.90
  )

  MetadataFactory::AVAIL_PACKAGES = [Package::S, Package::M, Package::L].freeze
  MetadataFactory::AVAIL_PROVIDERS = [Provider::MR, Provider::LP].freeze
  ##################################

  # Specialized exeption classes to propagate metadata generation exceptions
  class MetadataException < RuntimeError
    def initialize(message)
      super(message)
    end

    MetadataPackageNotFound = MetadataException.new 'Package not found'
    MetadataProviderNotFound = MetadataException.new 'Provider not found'
  end

  def find_package_by_size(size)
    package = AVAIL_PACKAGES.detect do |p|
      p.size_symbol == size || p.size_symbol.id2name == size
    end

    raise MetadataException::MetadataPackageNotFound if package.nil?

    package
  end

  def find_provider_by_short_name(short_name)
    provider = AVAIL_PROVIDERS.detect do |p|
      p.short_name_symbol ==
        short_name || p.short_name_symbol.id2name == short_name
    end

    raise MetadataException::MetadataProviderNotFound if provider.nil?

    provider
  end

  def find_smallest_small_package_shipping_price
    (AVAIL_PROVIDERS.map do |p|
      p.packaging[Package::S]
    end).min
  end

  Instance = MetadataFactory.new
end
