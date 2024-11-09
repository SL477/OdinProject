# frozen_string_literal: true

# Queen class
class Queen < ChessPiece
  def initialize(location, alignment, en_passant = false) # rubocop:disable Lint/UnusedMethodArgument,Style/OptionalBooleanParameter
    pic = if alignment == 'black'
            "\u265B"
          else
            "\u2655"
          end
    super(location, 9, alignment, 'Q', pic, 'queen')
  end

  # Returns strings of Column-Row
  def potential_moves(board)
    ret = []
    ret.push(*check_moves_in_loop(1, 1, board))
    ret.push(*check_moves_in_loop(-1, 1, board))
    ret.push(*check_moves_in_loop(1, -1, board))
    ret.push(*check_moves_in_loop(-1, -1, board))
    ret.push(*check_moves_in_loop(1, 0, board))
    ret.push(*check_moves_in_loop(-1, 0, board))
    ret.push(*check_moves_in_loop(0, 1, board))
    ret.push(*check_moves_in_loop(0, -1, board))
    ret
  end
end
