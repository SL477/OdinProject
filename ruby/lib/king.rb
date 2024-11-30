# frozen_string_literal: true

# King class
class King < ChessPiece
  def initialize(location, alignment, en_passant = false) # rubocop:disable Lint/UnusedMethodArgument,Style/OptionalBooleanParameter
    pic = if alignment == 'black'
            "\u265A"
          else
            "\u2654"
          end
    super(location, 100, alignment, 'K', pic, 'king')
  end

  # Returns array of strings of Column-Row and special move
  def potential_moves(board) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    ret = []
    cells_to_check = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    cells_to_check.each do |cell_increments|
      cell = [location[0] + cell_increments[0], location[1] + cell_increments[1]]
      ret.push([:"#{cell[1]}#{cell[0]}", nil]) if is_valid_location?(cell, board)[0]
    end

    # castling
    unless @moved
      # Get the two casles
      rooks = board.flatten.compact.select { |cell| cell.alignment == @alignment && cell.type == 'rook' }
      rooks.each do |rook|
        next unless rook.can_castle?(board)

        min_start = [rook.location[1], @location[1]].min
        max_start = [rook.location[1], @location[1]].max
        diff = max_start - min_start
        ret.push([:"#{rook.location[1]}#{rook.location[0]}", "castle_#{if diff == 4
                                                                         '0-0-0'
                                                                       else
                                                                         '0-0'
                                                                       end}"])
      end
    end

    ret
  end
end
