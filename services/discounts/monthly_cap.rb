module Discounts
  MONTHLY_CAP = lambda { |t, tt, dt|
    tmonth = t.date.year * 12 + t.date.month
    sum_month_discounts = 0.0

    dt.each do |k, v|
      sum_month_discounts += v if k.date.year * 12 + k.date.month == tmonth
    end

    10 - sum_month_discounts # TODO Normally 10 EUR shouldnt be hardcoded there
  }
end
