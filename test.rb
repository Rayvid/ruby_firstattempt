begin
  require 'date'

  require_relative './model/package.rb'
  require_relative './model/provider.rb'
  require_relative './data/metadata_factory.rb'
  require_relative './data/text_file_repository.rb'
  require_relative './model/transaction/transaction.rb'
  require_relative './model/transaction/invalid_transaction.rb'
  require_relative './model/transaction/valid_transaction.rb'
  require_relative './services/discounts_calculator.rb'
  require_relative './services/discounts/monthly_cap.rb'
  require_relative './services/discounts/small_matches_lowest_provider.rb'
  require_relative './services/discounts/third_lp_is_free.rb'
end

if ARGV.empty?
  repository = TextFileRepository.new
else
  repository = TextFileRepository.new ARGV[0]
end

transactions = repository.read_all

discounts =
  DiscountsCalculator
  .new(Discounts::MONTHLY_CAP)
  .push_discount_fn(Discounts::SMALL_MATCHES_LOWEST_PROVIDER)
  .push_discount_fn(Discounts::THIRD_LP_IS_FREE)
  .calculate_discounts_for_transactions(transactions)

# Hacking output directly there, of course, normally there should be some formatter
transactions.each do |t|
  if t.is_a?(ValidTransaction)
    if discounts[t].nil?
      puts "#{t.raw_string} #{t.provider.packaging[t.package].round(2)} -"
    else
      puts "#{t.raw_string} #{(t.provider.packaging[t.package] - discounts[t]).round(2)} #{discounts[t].round(2)}"
    end
  else
    puts "#{t.raw_string} Ignored"
  end
end
