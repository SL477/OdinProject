# frozen_string_literal: true

# Rook class
class Rook < ChessPiece
  def initialize(location, alignment, en_passant = false) # rubocop:disable Lint/UnusedMethodArgument,Style/OptionalBooleanParameter
    pic = if alignment == 'black'
            "\u265C"
          else
            "\u2656"
          end
    super(location, 5, alignment, 'R', pic, 'rook')
  end

  # Returns array of strings of Column-Row and special move
  def potential_moves(board)
    ret = []
    # TODO: castling
    ret.push(*check_moves_in_loop(1, 0, board))
    ret.push(*check_moves_in_loop(-1, 0, board))
    ret.push(*check_moves_in_loop(0, 1, board))
    ret.push(*check_moves_in_loop(0, -1, board))
    ret
  end

  def can_castle?(board) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    return false if @moved

    # get the king
    kings = board.flatten.select { |cell| !cell.nil? && cell.type == 'king' && cell.alignment == @alignment }
    return false if kings.length <= 0

    king = kings[0]

    return false if king.moved

    # get the cells to check for attacks
    rook_location = @location
    king_location = king.location
    min_start = [rook_location[1], king_location[1]].min
    max_start = [rook_location[1], king_location[1]].max
    mid_locations = (min_start..max_start).map { |i| [rook_location[0], i] }[1..-2]

    # check if the cells between the rook and king are empty
    mid_locations.each { |cell| return false unless board[cell[0]][cell[1]].nil? }

    # cells to check
    mid_locations.push(rook_location, king_location)
    cells_to_check = mid_locations.map { |i| :"#{i[1]}#{i[0]}" }

    # get the cells being attacked by the other side
    other_side = board.flatten.compact.select { |cell| !cell.nil? && cell.alignment != @alignment }
    attacked_cells = []
    other_side.each { |cell| attacked_cells.push(*cell.potential_moves(board)) } # rubocop:disable Style/MapIntoArray
    attacked_cells = attacked_cells.map { |cell| cell[0] }
    cells_to_check.each { |cell| return false if attacked_cells.include?(cell) }

    true
  end
end
