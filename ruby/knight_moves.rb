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
  destination[1] = origin[1] + a + 2b + 2c + d - e  - 2f - 2g - h
  destination[0] = origin[0] + 2a + b - c - 2d - 2e - f  + g + 2h
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
    ret.push([origin[0] + 2, origin[1] + 1])
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