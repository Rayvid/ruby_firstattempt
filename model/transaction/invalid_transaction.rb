begin
  require_relative './transaction.rb'
end

# Invalid shipment transactions
class InvalidTransaction < Transaction
  attr_accessor :error_text

  def initialize(raw_string, error_text)
    super(raw_string)

    @error_text = error_text
  end

  def to_s
    "#{@raw_string} - #{@error_text}"
  end
end
