# frozen_string_literal: true

def knight_moves(origin, destination) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
  # potential moves
  # x + 2y, [x + 1, y + 2]
  # 2x + y, [x + 2, y + 1]
  # 2x - y, [x + 2, y - 1]
  # x - 2y, [x + 1, y - 2]
  # -x -2y, [x - 1, y - 2]
  # -2x - y,[x - 2, y - 1]
  # -2x + x,[x - 2, y + 1]
  # -x + 2y,[x - 1, y + 2]
  # https://stackoverflow.com/questions/39524464/knights-travails-and-binary-search-tree
  ret = []
  return ret if !is_valid_location?(origin) || !is_valid_location?(destination)

  x_diff = destination[0] - origin[0]
  y_diff = destination[1] - origin[1]
  return ret if x_diff.zero? && y_diff.zero?

  # destination[1] = origin[1] + a + 2b + 2c + d - e  - 2f - 2g - h
  # destination[0] = origin[0] + 2a + b - c - 2d - 2e - f  + g + 2h

  # Build move graph
  graph = Graph.new
  (0..7).each do |i|
    (0..7).each do |j|
      graph.add_node([i, j])
    end
  end

  # available moves
  (0..7).each do |i| # rubocop:disable Style/CombinableLoops
    (0..7).each do |j|
      knight_available_moves([i, j]).each { |k| graph.add_edge([i, j], k) }
    end
  end

  # graph.print_graph

  # Dijkstra algorithm, from https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
  dist = {}
  prev = {}
  q = []
  graph.nodes.each_key do |node|
    dist[node] = 1_000_000
    prev[node] = nil
    q.push(node)
  end
  dist[origin] = 0
  should_end = false

  while !should_end && q.length.positive?
    # get vertex with minimum dist u in q
    u = get_min_dist_node(dist, q)
    # remove u from q
    q.delete(u)
    if u[0] == destination[0] && u[1] == destination[1]
      should_end = true

    else
      # visit each neighbour v of u still in q
      graph.nodes[u].each do |v|
        next unless q.include?(v)

        alt = dist[u] + 1
        if alt < dist[v]
          dist[v] = alt
          prev[v] = u
        end
      end
    end
  end

  # get the shortest path
  if should_end
    u = destination
    if !prev[u].nil? || u == origin
      until u.nil?
        ret.unshift(u)
        u = prev[u]
      end
    end
  end

  ret
end

def get_min_dist_node(dist, q)
  ret = nil
  min_distance = 10_000_000
  q.each do |node|
    if dist[node] < min_distance
      min_distance = dist[node]
      ret = node
    end
  end
  ret
end

def knight_available_moves(origin) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
  ret = []
  ret.push([origin[0] + 1, origin[1] + 2]) if is_valid_location?([origin[0] + 1, origin[1] + 2])
  ret.push([origin[0] + 2, origin[1] + 1]) if is_valid_location?([origin[0] + 2, origin[1] + 1])
  ret.push([origin[0] + 2, origin[1] - 1]) if is_valid_location?([origin[0] + 2, origin[1] - 1])
  ret.push([origin[0] + 1, origin[1] - 2]) if is_valid_location?([origin[0] + 1, origin[1] - 2])
  ret.push([origin[0] - 1, origin[1] - 2]) if is_valid_location?([origin[0] - 1, origin[1] - 2])
  ret.push([origin[0] - 2, origin[1] - 1]) if is_valid_location?([origin[0] - 2, origin[1] - 1])
  ret.push([origin[0] - 2, origin[1] + 1]) if is_valid_location?([origin[0] - 2, origin[1] + 1])
  ret.push([origin[0] - 1, origin[1] + 2]) if is_valid_location?([origin[0] - 1, origin[1] + 2])
  ret
end

def is_valid_location?(cell) # rubocop:disable Naming/PredicateName
  cell[0] >= 0 && cell[0] < 8 && cell[1] >= 0 && cell[1] < 8
end

class Graph # rubocop:disable Style/Documentation
  attr_accessor :nodes

  # from https://www.geeksforgeeks.org/how-to-implement-graph-in-ruby/
  def initialize
    @nodes = Hash.new { |hash, key| hash[key] = [] }
  end

  def add_node(value)
    raise ArgumentError, 'Node value cannot be nil' if value.nil?

    @nodes[value]
  end

  def add_edge(node1, node2)
    raise ArgumentError, "Nodes #{node1} and #{node2} do not exist" unless @nodes[node1] && @nodes[node2]

    @nodes[node1] << node2
  end

  def print_graph
    @nodes.each do |node, neighbours|
      puts "#{node} => #{neighbours}"
    end
  end
end

puts "knight_moves([0,0],[1,2]) => #{knight_moves([0, 0], [1, 2])}"

puts "knight_moves([0,0],[3,3]) => #{knight_moves([0, 0], [3, 3])}"

puts "knight_moves([3,3],[0,0]) => #{knight_moves([3, 3], [0, 0])}"

puts "knight_moves([0,0],[7,7]) => #{knight_moves([0, 0], [7, 7])}"
