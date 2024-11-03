# frozen_string_literal: true

# Queen class
class Queen < ChessPiece
  def initialize(location, alignment, en_passant = false) # rubocop:disable Lint/UnusedMethodArgument,Style/OptionalBooleanParameter
    pic = if alignment == 'black'
            "\u265B"
          else
            "\u2655"
          end
    super(location, 9, alignment, 'Q', pic, 'queen')
  end
end
