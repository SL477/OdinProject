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
        if cur_node.value < value # rubocop:disable Style/IfInsideElse
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

  def delete_node(root, x) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    return root if root.nil?

    # If its a subtree
    if root.value > x
      root.left = delete_node(root.left, x)
    elsif root.value < x
      root.right = delete_node(root.right, x)
    else
      return root.right if root.left.nil?
      return root.left if root.right.nil?

      # both children
      successor = get_successor(root)
      root.value = successor.value
      root.right = delete_node(root.right, successor.value)
    end
    root
  end

  def get_successor(root)
    root = root.right
    root = root.left while !root.nil? && !root.left.nil?
    root
  end
end

t = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
t.pretty_print
t.root = t.delete_node(t.root, 9)
t.pretty_print
