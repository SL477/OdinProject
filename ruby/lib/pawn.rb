# frozen_string_literal: true

# Pawn class
class Pawn < ChessPiece
  def initialize(location, alignment)
    pic = if alignment == 'black'
            "\u265F"
          else
            "\u2659"
          end
    super(location, 1, alignment, '', pic)
  end
end
