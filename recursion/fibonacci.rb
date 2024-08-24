def fibs(number)
  ret = []
  i = 0
  j = 1
  for a in 0..(number - 1)
    if a == 0
      ret.push(i)
    elsif a == 1
      ret.push(j)
    else
      next_item = i + j
      ret.push(next_item)
      i = j
      j = next_item
    end
  end
  ret
end

def fibs_rec(number)
  if number <= 1
    return [0]
  elsif number == 2
    return fibs_rec(number - 1).concat([1])
  else
    i = fibs_rec(number - 1)
    return i.concat([i[-1] + i[-2]])
  end
end

print fibs(28)
print fibs_rec(28)