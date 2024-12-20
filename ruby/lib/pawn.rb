# frozen_string_literal: true

# Pawn class
class Pawn < ChessPiece
  # DONE: set en_passant to true on the first move and then set to false on subsequent moves
  def initialize(location, alignment, en_passant = false) # rubocop:disable Style/OptionalBooleanParameter
    pic = if alignment == 'black'
            "\u265F"
          else
            "\u2659"
          end
    super(location, 1, alignment, '', pic, 'pawn')
    @en_passant = en_passant
  end

  # Returns strings of Column-Row
  def potential_moves(board) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    ret = []
    if @alignment == 'black'
      square_in_front = if @location[0] - 1 >= 0
                          board[@location[0] - 1][@location[1]].nil?
                        else
                          false
                        end
      promotion = ('promotion' if @location[0] - 1 <= 0)
      if square_in_front
        ret.push([:"#{@location[1]}#{@location[0] - 1}", promotion])

        if !@moved && board[@location[0] - 2][@location[1]].nil?
          ret.push([:"#{@location[1]}#{@location[0] - 2}",
                    'doubleStep'])
        end
      end

      # left attack
      if is_valid_location?([@location[0] - 1, @location[1] - 1], board)[0]
        left_attack_square = board[@location[0] - 1][@location[1] - 1]
        if !left_attack_square.nil? && left_attack_square.alignment == 'white'
          ret.push([:"#{@location[1] - 1}#{@location[0] - 1}", promotion])
        end
      end

      # right attack
      if is_valid_location?([@location[0] - 1, @location[1] + 1], board)[0]
        right_attack_square = board[@location[0] - 1][@location[1] + 1]
        if !right_attack_square.nil? && right_attack_square.alignment == 'white'
          ret.push([:"#{@location[1] + 1}#{@location[0] - 1}", promotion])
        end
      end

      # En Passant
      if @location[0] == 3
        # if there is one on the left or right & its en_passant is true
        # left
        if @location[1].positive?
          left_attack_square = board[@location[0]][@location[1] - 1]
          if !left_attack_square.nil? && left_attack_square.en_passant && left_attack_square.alignment == 'white' # rubocop:disable Metrics/BlockNesting
            ret.push([:"#{@location[1] - 1}#{@location[0] - 1}", "enPassant_#{@location[1] - 1}#{@location[0]}"])
          end
        end

        # right
        if @location[1] < 6
          right_attack_square = board[@location[0]][@location[1] + 1]
          if !right_attack_square.nil? && right_attack_square.alignment == 'white' && right_attack_square.en_passant # rubocop:disable Metrics/BlockNesting
            ret.push([:"#{@location[1] + 1}#{@location[0] - 1}", "enPassant_#{@location[1] + 1}#{@location[0]}"])
          end
        end
      end
    else
      square_in_front = if @location[0] + 1 < 8
                          board[@location[0] + 1][@location[1]].nil?
                        else
                          false
                        end
      promotion = ('promotion' if @location[0] + 1 >= 7)
      if square_in_front
        ret.push([:"#{@location[1]}#{@location[0] + 1}", promotion])

        if !@moved && board[@location[0] + 2][@location[1]].nil?
          ret.push([:"#{@location[1]}#{@location[0] + 2}", 'doubleStep'])
        end
      end

      # left attack
      if is_valid_location?([@location[0] + 1, @location[1] - 1], board)[0]
        left_attack_square = board[@location[0] + 1][@location[1] - 1]
        if !left_attack_square.nil? && left_attack_square.alignment == 'black'
          ret.push([:"#{@location[1] - 1}#{@location[0] + 1}", promotion])
        end
      end

      # right attack
      if is_valid_location?([@location[0] + 1, @location[1] + 1], board)[0]
        right_attack_square = board[@location[0] + 1][@location[1] + 1]
        if !right_attack_square.nil? && right_attack_square.alignment == 'black'
          ret.push([:"#{@location[1] + 1}#{@location[0] + 1}", promotion])
        end
      end

      # En Passant
      if @location[0] == 4
        # if there is one on the left or right & its en_passant is true
        # left
        if @location[1].positive?
          left_attack_square = board[@location[0]][@location[1] - 1]
          if !left_attack_square.nil? && left_attack_square.en_passant && left_attack_square.alignment == 'black' # rubocop:disable Metrics/BlockNesting
            ret.push([:"#{@location[1] - 1}#{@location[0] + 1}", "enPassant_#{@location[1] - 1}#{@location[0]}"])
          end
        end

        # right
        if @location[1] < 6
          right_attack_square = board[@location[0]][@location[1] + 1]
          if !right_attack_square.nil? && right_attack_square.alignment == 'black' && right_attack_square.en_passant # rubocop:disable Metrics/BlockNesting
            ret.push([:"#{@location[1] + 1}#{@location[0] + 1}", "enPassant_#{@location[1] + 1}#{@location[0]}"])
          end
        end
      end
    end
    ret
  end
end
