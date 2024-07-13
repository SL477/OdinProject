dictionary = %w[below down go going horn how howdy it i low own part partner sit]

def substrings(word, dictionary)
  # word.scan(/(?=#{"hell"})/).count
  counts = {}
  dictionary.each do |val|
    counts[val] = word.downcase.scan(/(?=#{val})/).count if word.downcase.scan(/(?=#{val})/).count > 0
  end
  counts
end

puts substrings("Howdy partner, sit down! How's it going?", dictionary)
