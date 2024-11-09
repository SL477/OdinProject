# frozen_string_literal: true

# King class
class King < ChessPiece
  def initialize(location, alignment, en_passant = false)
    pic = if alignment == 'black'
            "\u265A"
          else
            "\u2654"
          end
    super(location, 100, alignment, 'K', pic, 'king')
  end

  # Returns array of strings of Column-Row and special move
  def potential_moves(board)
    # TODO castling
    ret = []
    cells_to_check = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    cells_to_check.each do |cell_increments|
      cell = [location[0] + cell_increments[0], location[1] + cell_increments[1]]
      if is_valid_location?(cell, board)
        ret.push([:"#{cell[1]}#{cell[0]}", nil])
      end
    end
    ret
  end
end
