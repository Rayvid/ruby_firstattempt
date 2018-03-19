begin
  require_relative '../../data/metadata_factory.rb'
end

module Discounts
  SMALL_MATCHES_LOWEST_PROVIDER = lambda { |t, tt|
    # This one is very ineffective to keep in lambda, normally should be context reference passed into lambda
    smallest_for_small =
      MetadataFactory::Instance.find_smallest_small_package_shipping_price
    #########################

    if t.package == Package::S
      if t.provider.packaging[Package::S] > smallest_for_small
        return t.provider.packaging[Package::S] - smallest_for_small
      end
    end

    0
  }
end
