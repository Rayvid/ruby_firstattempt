begin
  require_relative '../../data/metadata_factory.rb'
end

module Discounts
  THIRD_LP_IS_FREE = lambda { |t, tt|
    return 0 unless t.provider == Provider::LP

    l_count_before_curr = 0;
    tmonth = t.date.year * 12 + t.date.month
    tt.each do |tr|
      next unless tr.is_a?(ValidTransaction)

      break if tr == t
      l_count_before_curr += 1 if tr.provider == Provider::LP && tr.date.year * 12 + tr.date.month == tmonth
    end

    return t.provider.packaging[t.package] if l_count_before_curr == 2
    0
  }
end
