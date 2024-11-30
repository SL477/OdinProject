# frozen_string_literal: true

# Overload string
class String
  def colourise(white, move_to, capture_to, org_move) # rubocop:disable Metrics/MethodLength
    if move_to
      green_bg
    elsif capture_to
      red_bg
    elsif org_move
      blue_bg
    elsif white
      white_bg
    else
      black_bg
    end
  end

  def white_bg
    "\e[47m#{self}\e[0m"
  end

  def black_bg
    "\e[40m#{self}\e[0m"
  end

  def green_bg
    "\e[42m#{self}\e[0m"
  end

  def blue_bg
    "\e[43m#{self}\e[0m"
  end

  def red_bg
    "\e[41m#{self}\e[0m"
  end

  def colour_in(alignment)
    if alignment == 'black'
      black
    else
      white
    end
  end

  def black
    "\e[30m#{self}\e[0m"
  end

  def white
    "\e[37m#{self}\e[0m"
  end
end
