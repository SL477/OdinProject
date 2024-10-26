# frozen_string_literal: true

# Bishop class
class Bishop < ChessPiece
  def initialize(location, alignment)
    pic = if alignment == 'black'
            "\u265D"
          else
            "\u2657"
          end
    super(location, 3, alignment, 'B', pic, 'bishop')
  end
end
