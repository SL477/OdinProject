# frozen_string_literal: true

# King class
class King < ChessPiece
  def initialize(location, alignment)
    pic = if alignment == 'black'
            "\u265A"
          else
            "\u2654"
          end
    super(location, 100, alignment, 'K', pic)
  end
end
