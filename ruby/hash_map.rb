# frozen_string_literal: true

# This is part of https://www.theodinproject.com/lessons/ruby-hashmap
class HashMap
  attr_reader :keys

  def initialize
    @buckets = []
    @bucket_size = 16
    @keys = []
    @load_factor = 0.75
  end

  def check_index(index)
    raise IndexError if index.negative? || index >= @buckets.length
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord } # rubocop:disable Lint/AmbiguousOperatorPrecedence
    hash_code %= 32
    # print "\n hash #{hash_code}"
    hash_code
  end

  def set(key, value)
    index = hash(key)
    @buckets[index] = value
    @keys[index] = key
  end

  def get(key)
    index = hash(key)
    @buckets[index]
  end

  def has?(key)
    @keys.has?(key)
  end

  def remove(key)
    return nil unless has?(key)

    index = hash(key)
    @keys[index] = nil
    ret = @buckets[index]
    @buckets[index] = nil
    ret
  end

  def length
    cnt = 0
    @keys.each { |x| cnt += 1 unless x.nil? }
    cnt
  end

  def clear
    for i in 0..(@keys.length - 1) # rubocop:disable Style/For
      @keys[i] = nil
      @buckets[i] = nil
    end
  end

  def values
    @keys
  end

  def entries
    ret = []
    for i in 0..(@keys.length - 1) # rubocop:disable Style/For
      ret.append([@keys[i], @buckets[i]]) unless @keys[i].nil?
    end
    ret
  end
end

test = HashMap.new
test.set('apple', 'red')
test.set('banana', 'yellow')
test.set('carrot', 'orange')
test.set('dog', 'brown')
test.set('elephant', 'gray')
test.set('frog', 'green')
test.set('grape', 'purple')
test.set('hat', 'black')
test.set('ice cream', 'white')
test.set('jacket', 'blue')
test.set('kite', 'pink')
test.set('lion', 'golden')

test.set('moon', 'silver')

p test.entries
