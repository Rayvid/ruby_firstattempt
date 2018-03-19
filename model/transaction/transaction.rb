# Base class for all shipment transactions
class Transaction
  attr_accessor :raw_string

  def initialize(raw_string)
    @raw_string = raw_string
  end

  def to_s
    @raw_string
  end
end
