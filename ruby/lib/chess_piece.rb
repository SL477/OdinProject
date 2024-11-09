# frozen_string_literal: true

require 'json'

# Parent class for chess
class ChessPiece
  attr_reader :picture, :alignment
  attr_writer :moved
  attr_accessor :en_passant

  def initialize(location, points, alignment, notation, picture, type) # rubocop:disable Metrics/ParameterLists
    @moved = false
    @location = location
    @points = points
    @alignment = alignment
    @notation = notation
    @picture = picture
    @type = type,
            @en_passant = false
  end

  # Returns strings of Column-Row
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

  def is_valid_location?(cell, board)
    if cell[0] >= 0 && cell[0] < 8 && cell[1] >= 0 && cell[1] < 8
      cell_piece = board[cell[0]][cell[1]]
    
      return [cell_piece.nil? || cell_piece.alignment != alignment, !cell_piece.nil?]
    end
    return [false, false]
  end

  def check_moves_in_loop(row_increment, column_increment, board)
    ret = []
    row = @location[0] + row_increment
    column = @location[1] + column_increment
    should_stop = false
    until should_stop
      valid = is_valid_location?([row, column], board)
      if valid[0]
        ret.push(:"#{column}#{row}")
        if valid[1]
          should_stop = true
        end
      else
        should_stop = true
      end
      row += row_increment
      column += column_increment
    end
    ret
  end
end
