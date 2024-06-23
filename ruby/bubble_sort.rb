##
# This runs bubble sort on the numbers
def bubble_sort(numbers)
    has_changes = false

    loop do
        has_changes = false
        for i in 0..(numbers.length - 2)
            if numbers[i] > numbers[i + 1]
                has_changes = true
                left_number = numbers[i]
                right_number = numbers[i + 1]
                numbers[i + 1] = left_number
                numbers[i] = right_number
            end
        end

        break if not has_changes
    end

  return numbers
end

puts bubble_sort([4,3,78,2,0,2])