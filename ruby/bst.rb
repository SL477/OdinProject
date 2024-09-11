class Node
  attr_accessor :value, :left, :right
  include Comparable

  def initialize
    @value = nil
    @left = nil
    @right = nil
  end

  def <=>(other)
    @value <=> other.value
  end
end

class Tree
 attr_accessor :root
 def initialize(arr)
  @root = build_tree(arr)
 end

 def build_tree(arr)
  arr.sort
  arr = arr.uniq
  root = Node.new

  # take the centre item from the array
  until arr.length <= 0
    centre = (arr.length / 2).floor
    insert(arr[centre], root)
    arr.delete_at(centre)
  end
  root
 end

 def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, root)
    cur_node = root
    should_end = false
    until should_end
      if cur_node.value.nil?
        cur_node.value = value
        should_end = true
      else
        if cur_node.value < value
          # left
          if cur_node.left.nil?
            cur_node.left = Node.new
            cur_node.left.value = value
            should_end = true
          else
            cur_node = cur_node.left
          end
        else
          # right
          if cur_node.right.nil?
            cur_node.right = Node.new
            cur_node.right.value = value
            should_end = true
          else
            cur_node = cur_node.right
          end
        end
      end
    end
  end
end

t = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
t.pretty_print()