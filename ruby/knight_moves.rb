def knight_moves(origin, destination)
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
  if !is_valid_location?(origin) || !is_valid_location?(destination)
    return ret
  end
  x_diff = destination[0] - origin[0]
  y_diff = destination[1] - origin[1]
  if x_diff == 0 && y_diff == 0
    return ret
  end
  # destination[1] = origin[1] + a + 2b + 2c + d - e  - 2f - 2g - h
  # destination[0] = origin[0] + 2a + b - c - 2d - 2e - f  + g + 2h

  # Build move graph
  graph = Graph.new
  for i in 0..7 do
    for j in 0..7 do
      graph.add_node([i, j])
    end
  end

  # available moves
  for i in 0..7 do
    for j in 0..7 do
      graph.add_node([i, j])
    end
  end

  # available moves
  for i in 0..7 do
    for j in 0..7 do
      knight_available_moves([i, j]).each { |k| graph.add_edge([i, j], k)}
    end
  end

  # graph.print_graph

  # Dijkstra algorithm, from https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
  dist = Hash.new
  prev = Hash.new
  q = []
  graph.nodes.each do |node, neighbours|
    dist[node] = 1000000
    prev[node] = nil
    q.push(node)
  end
  dist[origin] = 0
  should_end = false

  while !should_end && q.length > 0
    # get vertex with minimum dist u in q
    u = get_min_dist_node(dist, q)
    # remove u from q
    q.delete(u)
    if u[0] == destination[0] && u[1] == destination[1]
      should_end = true

    else
      # visit each neighbour v of u still in q
      graph.nodes[u].each do |v|
        if q.include?(v)
          alt = dist[u] + 1
          if alt < dist[v]
            dist[v] = alt
            prev[v] = u
          end
        end
      end
    end
  end

  # get the shortest path
  if should_end
    u = destination
    if !prev[u].nil? || u = origin
      while !u.nil?
        ret.unshift(u)
        u = prev[u]
      end
    end
  end

  ret
end

def get_min_dist_node(dist, q)
  ret = nil
  min_distance = 10000000
  q.each do |node|
    if dist[node] < min_distance
      min_distance = dist[node]
      ret = node
    end
  end
  ret
end

def knight_available_moves(origin)
  ret = []
  if is_valid_location?([origin[0] + 1, origin[1] + 2])
    ret.push([origin[0] + 1, origin[1] + 2])
  end
  if is_valid_location?([origin[0] + 2, origin[1] + 1])
    ret.push([origin[0] + 2, origin[1] + 1])
  end
  if is_valid_location?([origin[0] + 2, origin[1] - 1])
    ret.push([origin[0] + 2, origin[1] - 1])
  end
  if is_valid_location?([origin[0] + 1, origin[1] - 2])
    ret.push([origin[0] + 1, origin[1] - 2])
  end
  if is_valid_location?([origin[0] - 1, origin[1] - 2])
    ret.push([origin[0] - 1, origin[1] - 2])
  end
  if is_valid_location?([origin[0] - 2, origin[1] - 1])
    ret.push([origin[0] - 2, origin[1] - 1])
  end
  if is_valid_location?([origin[0] - 2, origin[1] + 1])
    ret.push([origin[0] - 2, origin[1] + 1])
  end
  if is_valid_location?([origin[0] - 1, origin[1] + 2])
    ret.push([origin[0] - 1, origin[1] + 2])
  end
  ret
end

def is_valid_location?(cell)
  cell[0] >= 0 && cell[0] < 8 && cell[1] >= 0 && cell[1] < 8
end

class Graph
  attr_accessor :nodes
  # from https://www.geeksforgeeks.org/how-to-implement-graph-in-ruby/
  def initialize
    @nodes = Hash.new { | hash, key | hash[key] = [] }
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

puts "knight_moves([0,0],[1,2]) => #{knight_moves([0,0],[1,2])}"

puts "knight_moves([0,0],[3,3]) => #{knight_moves([0,0],[3,3])}"

puts "knight_moves([3,3],[0,0]) => #{knight_moves([3,3],[0,0])}"

puts "knight_moves([0,0],[7,7]) => #{knight_moves([0,0],[7,7])}"