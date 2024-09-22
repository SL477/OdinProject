# frozen_string_literal: true

class Node # rubocop:disable Style/Documentation
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

class Tree # rubocop:disable Style/Documentation
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

  def insert(value, root) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/PerceivedComplexity
    cur_node = root
    should_end = false
    until should_end
      if cur_node.value.nil?
        cur_node.value = value
        should_end = true
      else
        if cur_node.value > value # rubocop:disable Style/IfInsideElse
          # left
          if cur_node.left.nil? # rubocop:disable Metrics/BlockNesting
            cur_node.left = Node.new
            cur_node.left.value = value
            should_end = true
          else
            cur_node = cur_node.left
          end
        else
          # right
          if cur_node.right.nil? # rubocop:disable Metrics/BlockNesting,Style/IfInsideElse
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

  def delete_node(cur_node, x) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Naming/MethodParameterName
    # From https://www.geeksforgeeks.org/deletion-in-binary-search-tree/
    return cur_node if cur_node.nil?

    # pretty_print(cur_node)
    # print "value: #{x}"

    # If its a subtree
    if cur_node.value > x
      cur_node.left = delete_node(cur_node.left, x)
    elsif cur_node.value < x
      cur_node.right = delete_node(cur_node.right, x)
    else
      return cur_node.right if cur_node.left.nil?
      return cur_node.left if cur_node.right.nil?

      # both children
      successor = get_successor(cur_node)
      cur_node.value = successor.value
      # print "successor value: #{successor.value}"
      cur_node.right = delete_node(cur_node.right, successor.value)
    end
    cur_node
  end

  def get_successor(cur_node)
    cur_node = cur_node.right
    cur_node = cur_node.left while cur_node.nil? && cur_node.left.nil?
    cur_node
  end

  def find(val) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    cur_node = @root
    is_stop = false
    return cur_node if cur_node.value == val

    until is_stop
      # pretty_print(cur_node)
      # print "Val: #{val}, cur_node: #{cur_node.value}"
      if val == cur_node.value
        is_stop = true
        return cur_node
      elsif val > cur_node.value && cur_node.right.nil?
        is_stop = true
        cur_node = nil
        return nil
      elsif val > cur_node.value
        cur_node = cur_node.right
      elsif val < cur_node.value && cur_node.left.nil? # rubocop:disable Lint/DuplicateBranch
        is_stop = true
        cur_node = nil
        return nil
      else
        cur_node = cur_node.left
      end
    end
    cur_node
  end

  def level_order(&my_block) # rubocop:disable Metrics/MethodLength
    queue = [@root]
    arr = []
    until queue.length <= 0
      item = queue.shift
      unless item.nil? # rubocop:disable Style/Next
        queue.append(item.left)
        queue.append(item.right)
        if my_block.nil?
          arr.push(item.value)
        else
          yield item
        end
      end
    end

    return arr if my_block.nil? # rubocop:disable Style/RedundantReturn
  end

  def inorder(node = @root, &my_block)
    # go to the left, then root, then right tree
    arr = []
    arr.concat(inorder(node.left, &my_block)) unless node.left.nil?
    arr.push(node.value)
    yield node unless my_block.nil?
    arr.concat(inorder(node.right, &my_block)) unless node.right.nil?
    arr if my_block.nil?
  end

  def preorder(node = @root, &my_block)
    # At first visit the root then traverse left subtree and then traverse the right subtree.
    arr = []
    arr.push(node.value)
    yield node unless my_block.nil?
    arr.concat(preorder(node.left, &my_block)) unless node.left.nil?
    arr.concat(preorder(node.right, &my_block)) unless node.right.nil?
    arr if my_block.nil?
  end

  def postorder(node = @root, &my_block)
    # At first traverse left subtree then traverse the right subtree and then visit the root.
    arr = []
    arr.concat(postorder(node.left, &my_block)) unless node.left.nil?
    arr.concat(postorder(node.right, &my_block)) unless node.right.nil?
    arr.push(node.value)
    yield node unless my_block.nil?
    arr if my_block.nil?
  end

  def height(node = @root, ret = 0)
    # Height is defined as the number of edges in longest path from a given node to a leaf node.
    left_height = 1
    right_height = 1
    unless node.left.nil? # rubocop:disable Style/IfUnlessModifier
      left_height = height(node.left, ret) + 1
    end
    unless node.right.nil? # rubocop:disable Style/IfUnlessModifier
      right_height = height(node.right, ret) + 1
    end
    return left_height if left_height > right_height

    right_height
  end

  def depth(node = @root) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    cur_node = @root
    is_stop = false
    ret = 0
    return ret if cur_node.value == node.value

    until is_stop
      # pretty_print(cur_node)
      # print "Val: #{val}, cur_node: #{cur_node.value}"
      if node.value == cur_node.value
        is_stop = true
        return ret
      elsif node.value > cur_node.value && cur_node.right.nil?
        is_stop = true
        cur_node = nil
        return ret
      elsif node.value > cur_node.value
        cur_node = cur_node.right
      elsif node.value < cur_node.value && cur_node.left.nil?
        is_stop = true
        cur_node = nil
        return nil
      else
        cur_node = cur_node.left
      end
      ret += 1
    end
    cur_node
  end
end

t = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
t.pretty_print
t.root = t.delete_node(t.root, 9)
t.root = t.delete_node(t.root, 67)
t.pretty_print
t.pretty_print(t.find(3))
puts t.level_order
puts 'With block'
t.level_order { |block| print block.value }
puts ''
puts 'inorder'
puts t.inorder
puts ''
puts 'preorder'
puts t.preorder
puts ''
puts 'Postorder'
puts t.postorder
puts "height: #{t.height}"
puts "Depth of 5: #{t.depth(t.find(5))}"
