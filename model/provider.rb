# Class encapsulating shipping service provider entity
class Provider
  attr_accessor :full_name, :short_name_symbol, :packaging

  def initialize(full_name, short_name_symbol, packaging)
    @full_name = full_name
    @short_name_symbol = short_name_symbol
    @packaging = packaging
  end
end
