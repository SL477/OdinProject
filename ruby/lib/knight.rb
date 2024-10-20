# frozen_string_literal: true

# Knight class
class Knight < ChessPiece
  def initialize(location, alignment)
    pic = if alignment == 'black'
            "\u265E"
          else
            "\u2658"
          end
    super(location, 3, alignment, 'N', pic)
  end
end