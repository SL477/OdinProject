dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

def substrings(word, dictionary)
    # word.scan(/(?=#{"hell"})/).count
    counts = Hash.new()
    dictionary.each{|val| if word.downcase.scan(/(?=#{val})/).count > 0
        counts[val] = word.downcase.scan(/(?=#{val})/).count
end}
    counts
end

puts substrings("Howdy partner, sit down! How's it going?", dictionary)