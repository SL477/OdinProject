# frozen_string_literal: true

# Knight class
class Knight < ChessPiece
  def initialize(location, alignment, en_passant = false) # rubocop:disable Lint/UnusedMethodArgument,Style/OptionalBooleanParameter
    pic = if alignment == 'black'
            "\u265E"
          else
            "\u2658"
          end
    super(location, 3, alignment, 'N', pic, 'knight')
  end
end
