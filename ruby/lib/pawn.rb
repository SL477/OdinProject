# frozen_string_literal: true

# Pawn class
class Pawn < ChessPiece
  def initialize(location, alignment)
    pic = if alignment == 'black'
            "\u265F"
          else
            "\u2659"
          end
    super(location, 1, alignment, '', pic, 'pawn')
  end

  # Returns strings of Column-Row
  def potential_moves(board) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    ret = []
    # TODO: en passant
    if @alignment == 'black'
      square_in_front = board[@location[0] - 1][@location[1]].nil?
      if square_in_front
        ret.push(:"#{@location[1]}#{@location[0] - 1}")
        ret.push(:"#{@location[1]}#{@location[0] - 2}") if !@moved && board[@location[0] - 2][@location[1]].nil?
      end

      # left attack
      if (@location[1]).positive?
        left_attack_square = board[@location[0] - 1][@location[1] - 1]
        if !left_attack_square.nil? && left_attack_square.alignment == 'white'
          ret.push(:"#{@location[1] - 1}#{@location[0] - 1}")
        end
      end

      # right attack
      if @location[1] < 6
        right_attack_square = board[@location[0] - 1][@location[1] + 1]
        if !right_attack_square.nil? && right_attack_square.alignment == 'white'
          ret.push(:"#{@location[1] + 1}#{@location[0] - 1}")
        end
      end
    else
      square_in_front = board[@location[0] + 1][@location[1]].nil?
      if square_in_front
        ret.push(:"#{@location[1]}#{@location[0] + 1}")
        ret.push(:"#{@location[1]}#{@location[0] + 2}") if !@moved && board[@location[0] + 2][@location[1]].nil?
      end

      # left attack
      if (@location[1]).positive?
        left_attack_square = board[@location[0] + 1][@location[1] - 1]
        if !left_attack_square.nil? && left_attack_square.alignment == 'black'
          ret.push(:"#{@location[1] - 1}#{@location[0] + 1}")
        end
      end

      # right attack
      if @location[1] < 6
        right_attack_square = board[@location[0] + 1][@location[1] + 1]
        if !right_attack_square.nil? && right_attack_square.alignment == 'black'
          ret.push(:"#{@location[1] + 1}#{@location[0] + 1}")
        end
      end
    end
    ret
  end
end
