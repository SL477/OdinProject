# frozen_string_literal: true

# Parent class for chess
class ChessPiece
  attr_reader :picture, :alignment

  def initialize(location, points, alignment, notation, picture)
    @moved = false
    @location = location
    @points = points
    @alignment = alignment
    @notation = notation
    @picture = picture
  end

  # Returns strings of Column-Row
  def potential_moves(board) # rubocop:disable Lint/UnusedMethodArgument
    []
  end
end
