# frozen_string_literal: true

# Rook class
class Rook < ChessPiece
  def initialize(location, alignment, en_passant = false)
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
    # TODO castling
    ret.push(*check_moves_in_loop(1, 0, board))
    ret.push(*check_moves_in_loop(-1, 0, board))
    ret.push(*check_moves_in_loop(0, 1, board))
    ret.push(*check_moves_in_loop(0, -1, board))
    ret
  end
end
