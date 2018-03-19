# Class encapsulating package entity
class Package
  attr_accessor :size_symbol, :name

  def initialize(size_symbol, name)
    @size_symbol = size_symbol
    @name = name
  end
end
