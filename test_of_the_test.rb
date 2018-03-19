begin
  gem 'minitest', '>= 5.0.0'
  require 'minitest/autorun'
  require 'date'

  require_relative './services/discounts_calculator.rb'
  require_relative './data/metadata_factory.rb'
  require_relative './model/transaction/valid_transaction.rb'
end

class DiscountsCalculatorTests < Minitest::Test
  TRANSACTIONS_1 = [
    ValidTransaction.new(
      'whateva',
      Date.parse('2018-03-01'),
      Package::S,
      Provider::LP
    ), ValidTransaction.new(
      'whateva',
      Date.parse('2018-03-02'),
      Package::M,
      Provider::MR
    )].freeze

  def test_empty_discounts_calc_and_no_transactions_returns_0
    discounts =
      DiscountsCalculator
      .new(->(t, tt, disc) { Float::INFINITY })
      .calculate_discounts_for_transactions([])

    assert_empty(discounts)
  end

  def test_empty_discounts_calc_and_some_valid_transactions_returns_0
    discounts =
      DiscountsCalculator
      .new(->(t, tt, disc) { Float::INFINITY })
      .calculate_discounts_for_transactions(TRANSACTIONS_1)

    assert_empty(discounts)
  end

  def test_few_cents_discounts_and_no_transactions_returns_0
    discounts =
      DiscountsCalculator
      .new(->(t, tt, disc) { Float::INFINITY })
      .push_discount_fn(->(t, tt) { 0.02 })
      .calculate_discounts_for_transactions([])

    assert_empty(discounts)
  end

  def test_few_cents_discounts_and_some_valid_transactions_returns_expected_no
    discounts =
      DiscountsCalculator
      .new(->(t, tt, disc) { Float::INFINITY })
      .push_discount_fn(->(t, tt) { 0.02 })
      .calculate_discounts_for_transactions(TRANSACTIONS_1)

    assert_equal(discounts.sum { |k, v| v }, TRANSACTIONS_1.length * 0.02)
  end

  def test_discounts_and_some_valid_transactions_returns_expected_capped_no
    discounts =
      DiscountsCalculator
      .new(->(t, tt, disc) { disc.sum { |k, v| v } == (TRANSACTIONS_1.length - 1) * 0.20 ? 0.05 : Float::INFINITY })
      .push_discount_fn(->(t, tt) { 0.20 })
      .calculate_discounts_for_transactions(TRANSACTIONS_1)

    assert_equal(discounts.sum { |k, v| v }, TRANSACTIONS_1.length * 0.20 - 0.15)
  end
end
