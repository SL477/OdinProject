# frozen_string_literal: true

# Knight class
class Knight < ChessPiece
  def initialize(location, alignment, en_passant = false) # rubocop:disable Lint/UnusedMethodArgument,Style/OptionalBooleanParameter
    pic = if alignment == 'black'
            "\u265E"
          else
            "\u2658"
          end
    super(location, 3, alignment, 'N', pic, 'knight')
  end

  def is_valid_location?(cell, cell_piece) # rubocop:disable Naming/PredicateName
    cell[0] >= 0 && cell[0] < 8 && cell[1] >= 0 && cell[1] < 8 && (cell_piece.nil? || cell_piece.alignment != alignment)
  end

  # Returns strings of Column-Row
  def potential_moves(board) # rubocop:disable Metrics/AbcSize
    ret = []
    cells = [[@location[0] + 1, @location[1] + 2], [@location[0] + 2, @location[1] + 1],
             [@location[0] + 2, @location[1] - 1], [@location[0] + 1, @location[1] - 2],
             [@location[0] - 1, @location[1] - 2], [@location[0] - 2, @location[1] - 1],
             [@location[0] - 2, @location[1] + 1], [@location[0] - 1, @location[1] + 2]]
    cells.each do |cell|
      ret.push(:"#{cell[1]}#{cell[0]}") if cell[0] >= 0 && cell[0] < 8 && cell[1] >= 0 && cell[1] < 8 &&
                                           is_valid_location?(cell, board[cell[0]][cell[1]])
    end
    ret
  end
end
