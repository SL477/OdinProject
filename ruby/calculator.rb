# frozen_string_literal: true

class Calculator # rubocop:disable Style/Documentation
  def add(*args)
    sum = 0
    args.each do |i|
      sum += i
    end
    sum
  end

  def multiply(*args)
    ret = 1
    args.each do |i|
      ret *= i
    end
    ret
  end
end
