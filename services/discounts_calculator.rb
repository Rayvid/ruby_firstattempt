begin
  require 'date'
  require_relative '../model/transaction/valid_transaction.rb'
end

# Semi universal discount calculator with assumptions:
# 1. no lookahead
# 2. there will be always enough data fed into calculator to do look behind
class DiscountsCalculator
  attr_accessor :discounts_pipeline, :max_discount_constrains_fn

  def initialize(max_discount_constrains_fn) # Constraining function (to be able to cap discount). fn signature |transaction, transactions, discounts_already_made|
    @discounts_pipeline = []
    @max_discount_constrains_fn = max_discount_constrains_fn
  end

  # Push another discount into discounts pipeline. fn signature |transaction, transactions|
  def push_discount_fn(discount_fn)
    @discounts_pipeline << discount_fn
    self
  end

  def calculate_discounts_for_transactions(transactions)
    discounted_transactions = {}

    transactions.each do |t|
      next unless t.is_a?(ValidTransaction)

      sum_discounts = 0.0
      @discounts_pipeline.each do |discount|
        sum_discounts += discount.call(t, transactions)
      end

      next if sum_discounts.zero?

      max_discount_possible =
        max_discount_constrains_fn.call(t, transactions, discounted_transactions)

      next if max_discount_possible.zero?

      discounted_transactions[t] = [max_discount_possible, sum_discounts].min
    end

    discounted_transactions
  end
end
