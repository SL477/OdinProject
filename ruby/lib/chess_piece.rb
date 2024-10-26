# frozen_string_literal: true

require 'json'

# Parent class for chess
class ChessPiece
  attr_reader :picture, :alignment

  def initialize(location, points, alignment, notation, picture, type)
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

  def to_json
    JSON.dump({
      :moved => @moved,
      :location => @location,
      :points => @points,
      :alignment => @alignment,
      :notation => @notation,
      :picture => @picture,
      :type => @type
    })
  end

  def self.from_json(string)
    data = JSON.load string
    self.new(data['location'], data['points'], data['alignment'], data['notation'], data['picture'], data['type'])
  end
end
