# frozen_string_literal: true

require 'json'

# Parent class for chess
class ChessPiece
  attr_reader :picture, :alignment, :type, :location
  attr_accessor :en_passant, :moved

  def initialize(location, points, alignment, notation, picture, type) # rubocop:disable Metrics/ParameterLists
    @moved = false
    @location = location
    @points = points
    @alignment = alignment
    @notation = notation
    @picture = picture
    @type = type
    @en_passant = false
  end

  # Returns array of strings of Column-Row and special move
  def potential_moves(board) # rubocop:disable Lint/UnusedMethodArgument
    []
  end

  def to_json(*_args)
    JSON.dump({
                moved: @moved,
                location: @location,
                points: @points,
                alignment: @alignment,
                notation: @notation,
                picture: @picture,
                type: @type,
                en_passant: @en_passant
              })
  end

  def self.from_json(string)
    data = JSON.parse string
    new(data['location'], data['alignment'], data['en_passant'])
  end

  def is_valid_location?(cell, board) # rubocop:disable Naming/PredicateName
    if cell[0] >= 0 && cell[0] < 8 && cell[1] >= 0 && cell[1] < 8
      cell_piece = board[cell[0]][cell[1]]

      return [cell_piece.nil? || cell_piece.alignment != alignment, !cell_piece.nil?]
    end
    [false, false]
  end

  def check_moves_in_loop(row_increment, column_increment, board) # rubocop:disable Metrics/MethodLength
    ret = []
    row = @location[0] + row_increment
    column = @location[1] + column_increment
    should_stop = false
    until should_stop
      valid = is_valid_location?([row, column], board)
      if valid[0]
        ret.push([:"#{column}#{row}", nil])
        should_stop = true if valid[1]
      else
        should_stop = true
      end
      row += row_increment
      column += column_increment
    end
    ret
  end

  def in_check?(board) # rubocop:disable Metrics/AbcSize,Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
    # get the current sides king and its location
    kings = board.flatten.select { |cell| !cell.nil? && cell.alignment == @alignment && cell.type == 'king' }
    return false if kings.length <= 0

    king = kings[0]
    king_location = :"#{king.location[1]}#{king.location[0]}"

    # get all the opposite sides pieces
    opposite_pieces = board.flatten.select { |cell| !cell.nil? && cell.alignment != @alignment }

    # get their potential moves and if the king is in those moves
    opposite_pieces.each do |piece|
      moves = piece.potential_moves(board)
      return true if moves.flatten.include?(king_location)
    end

    false
  end
end
