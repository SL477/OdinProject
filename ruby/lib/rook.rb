# frozen_string_literal: true

# Rook class
class Rook < ChessPiece
  def initialize(location, alignment)
    pic = if alignment == 'black'
            "\u265C"
          else
            "\u2656"
          end
    super(location, 5, alignment, 'R', pic)
  end
end
