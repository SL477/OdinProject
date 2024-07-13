def stock_picker(price_array)
  best_profit = -1.0 / 0.0
  best_buy = -1
  best_sell = -1

  price_array.each_with_index do |val, index|
    for i in (index + 1)..(price_array.length - 1)
      next unless price_array[i] - val > best_profit

      best_profit = price_array[i] - val
      best_buy = index
      best_sell = i
    end
  end

  [best_buy, best_sell]
end

puts stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])
