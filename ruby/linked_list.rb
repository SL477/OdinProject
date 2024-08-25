class  LinkedList
  attr_accessor :first_node
  def initialize
    @first_node = nil
  end

  def append(value)
    if @first_node.nil?
      @first_node = Node.new
      @first_node.value = value
    else
      current_node = @first_node
      until current_node.next_node.nil?
        current_node = current_node.next_node
      end
      current_node.next_node = Node.new
      current_node.next_node.value = value
    end
  end

  def prepend(value)
    if @first_node.nil?
      @first_node = Node.new
      @first_node.value = value
    else
      new_node = Node.new
      new_node.value = value
      new_node.next_node = @first_node
      @first_node = new_node
    end
  end

  def size
    cnt = 0
    current_node = @first_node
    until current_node.nil?
      cnt += 1
      current_node = current_node.next_node
    end
    cnt
  end

  def head
    return @first_node
  end

  def tail
    ret = @first_node
    until ret.next_node.nil?
      ret = ret.next_node
    end
    ret
  end

  def at(index)
    cnt = index
    ret = @first_node
    until cnt <= 0 || ret.nil?
      ret = @first_node.next_node
      cnt -=1
    end
    if cnt > 0
      ret = nil
    end
    ret
  end

  def pop
    ret = @first_node
    ret_minus1 = nil
    until ret.next_node.nil?
      ret_minus1 = ret
      ret = ret.next_node
    end

    if ret_minus1.nil?
      @first_node = nil
    else
      ret_minus1.next_node = nil
    end
    ret
  end

  def contains?(value)
    ret = false
    next_node = @first_node
    until next_node.nil? || ret
      ret = next_node.value.eql? value
      next_node = next_node.next_node
    end
    ret
  end

  def find(value)
    ret = nil
    next_node = @first_node
    cnt = 0
    until next_node.nil? || !ret.nil?
      if next_node.value.eql? value
        ret = cnt
      end
      cnt += 1
      next_node = next_node.next_node
    end
    ret
  end

  def to_s
    ret = ''
    next_node = @first_node
    until next_node.nil?
      if ret.eql? ''
        ret = "(#{next_node.value})"
      else
        ret = "#{ret} -> (#{next_node.value})"
      end
      next_node = next_node.next_node
    end
    ret = "#{ret} -> nil"
    ret
  end

  def insert_at(value, index)
    cnt = index
    next_node = @first_node
    last_node = nil
    until cnt <= 0
      last_node = next_node
      next_node = next_node.next_node
      cnt -= 1
    end
    new_node = Node.new
    new_node.value = value
    new_node.next_node = next_node
    last_node.next_node = new_node
  end

  def remove_at(index)
    if index.eql? 0
      @first_node = @first_node.next_node
    else
      cnt = index
      next_node = @first_node
      last_node = nil
      until cnt <= 0
        last_node = next_node
        next_node = next_node.next_node
        cnt -= 1
      end

      last_node.next_node = next_node.next_node
    end
  end
end

class Node
  attr_accessor :value, :next_node
  def initialize
    @value = nil
    @next_node = nil
  end
end

ll = LinkedList.new
ll.append('hi')
print ll.first_node.value

ll.prepend('there')
p ll.first_node

print "size: #{ll.size()}\n"
print ll.head().value
print "\nTail: #{ll.tail().value}"
print "\n0: #{ll.at(0).value}"
print "\n1: #{ll.at(1).value}"
print "\nContains hi: #{ll.contains?('hi')}"
print "\nContains there: #{ll.contains?('there')}"
print "\nFind hi: #{ll.find('hi')}"
print "\nFind there: #{ll.find('there')}"
print "\nto_s: #{ll.to_s()}"
print "\nPop: #{ll.pop().value}"
print "\nsize: #{ll.size()}"
print "\nContains bye: #{ll.contains?('bye')}"
print "\nFind bye: #{ll.find('bye')}"
print "\nto_s: #{ll.to_s()}"


list = LinkedList.new

list.append('dog')
list.append('cat')
list.append('parrot')
list.append('hamster')
list.append('snake')
list.append('turtle')
puts list

list.insert_at('Eagle', 3)
puts list

list.remove_at(3)
puts list

list.remove_at(0)
puts list