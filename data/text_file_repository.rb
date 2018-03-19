begin
  require_relative '../model/transaction/invalid_transaction.rb'
  require_relative '../model/transaction/valid_transaction.rb'
end

# Simplest possible implementation to fetch model from file
class TextFileRepository
  attr_accessor :file_name

  def initialize(file_name = 'input.txt')
    @file_name = file_name
  end

  def read_all
    transactions = []

    File.open(@file_name, 'r') do |f|
      f.each_line do |line|
        begin
          line = line.strip
          transactions << ValidTransaction.parse(line)
        rescue StandardError => ex
          transactions << InvalidTransaction.new(line, ex)
        end
      end
    end

    transactions
  end
end
