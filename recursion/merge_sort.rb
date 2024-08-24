def merge_sort(arr)
  if arr.length() <= 1
    return arr
  else
    # split array in 2
    len = (arr.length() / 2).floor()
    a = merge_sort(arr[0, len])
    b = merge_sort(arr[len, arr.length() - len])
    ret = []
    while a.length() > 0 || b.length() > 0
      if a.length() <= 0
        item = b.shift()
        ret.push(item)
      elsif b.length() <= 0
        item = a.shift()
        ret.push(item)
      elsif a[0] < b[0]
        item = a.shift()
        ret.push(item)
      else
        item = b.shift()
        ret.push(item)
      end
    end
    return ret
  end
end

# print merge_sort([3, 2, 1, 13, 8, 5, 0, 1])
print merge_sort([105, 79, 100, 110])