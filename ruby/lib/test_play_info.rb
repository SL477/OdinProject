# frozen_string_literal: true

# Get information about the run
class TestPlayInfo
  attr_accessor :score, :index

  def initialize(score, index)
    @score = score
    @index = index
  end
end
