# frozen_string_literal: true

# King class
class King < ChessPiece
  def initialize(location, alignment, en_passant = false)
    pic = if alignment == 'black'
            "\u265A"
          else
            "\u2654"
          end
    super(location, 100, alignment, 'K', pic, 'king')
  end
end
