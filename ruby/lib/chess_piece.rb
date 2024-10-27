# frozen_string_literal: true

require 'json'

# Parent class for chess
class ChessPiece
  attr_reader :picture, :alignment
  attr_writer :moved

  def initialize(location, points, alignment, notation, picture, type) # rubocop:disable Metrics/ParameterLists
    @moved = false
    @location = location
    @points = points
    @alignment = alignment
    @notation = notation
    @picture = picture
    @type = type
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
                type: @type
              })
  end

  def self.from_json(string)
    data = JSON.parse string
    new(data['location'], data['alignment'])
  end
end
