# frozen_string_literal: true

require_relative 'lib/chess_piece'
require_relative 'lib/pawn'
require_relative 'lib/bishop'
require_relative 'lib/knight'
require_relative 'lib/rook'
require_relative 'lib/queen'
require_relative 'lib/king'

# Chess for the odin project
class Chess
  attr_accessor :board

  def initialize # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    w = 'white'
    b = 'black'
    @board = [[Rook.new([0, 0], w), Knight.new([0, 1], w), Bishop.new([0, 2], w), Queen.new([0, 3], w),
               King.new([0, 4], w), Bishop.new([0, 5], w), Knight.new([0, 6], w), Rook.new([0, 7], w)]]
    white_pawn_row = (0..7).map { |i| Pawn.new([1, i], w) }
    @board.push(white_pawn_row)
    4.times do
      tmp = (0..7).map { nil }
      @board.push(tmp)
    end
    black_pawn_row = (0..7).map { |i| Pawn.new([6, i], b) }
    @board.push(black_pawn_row)
    @board.push([Rook.new([7, 0], b), Knight.new([7, 1], b), Bishop.new([7, 2], b), Queen.new([7, 3], b),
                 King.new([7, 4], b), Bishop.new([7, 5], b), Knight.new([7, 6], b), Rook.new([7, 7], b)])
    @history = []
    @turn = 1
  end

  def display(potential_moves = {}) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    # pp @board
    puts "Turn - #{@turn}"
    white = true
    (0..7).reverse_each do |row|
      white = row.odd?
      row_word = "#{row + 1} "
      @board[row].each_with_index do |cell, col|
        row_word += if cell.nil?
                      '    '.colourise(white, potential_moves.key?(:"#{col}#{row}"), false)
                    else
                      " #{cell.picture}  ".colour_in(cell.alignment).colourise(white, false,
                                                                               potential_moves.key?(:"#{col}#{row}"))
                    end
        white = !white
      end
      puts row_word
    end
    puts '    A   B   C   D   E   F   G   H'
  end

  def menu
    puts '1 - Make move. E.g. 1 A2 A4'
    puts '2 - Show moves. E.g 2 A2'
    puts '3 - Save'
    puts '4 - Show history'
  end

  def show_history
    @history.each do |move|
      puts move
    end
  end

  def number_or_minus1(string)
    Integer(string || '')
  rescue ArgumentError
    -1
  end

  def get_row_column(column_row)
    column_row = column_row.strip
    split = column_row.chars
    columns = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7 }

    return false unless columns.key?(split[0].downcase.to_sym)

    col = columns[split[0].downcase.to_sym]

    row = number_or_minus1(split[1])

    return false if row <= 0 || row > 8

    row -= 1

    [row, col]
  end

  def show_potential_moves(column_row) # rubocop:disable Metrics/MethodLength
    row_col = get_row_column(column_row)
    unless row_col
      puts 'Invalid cell'
      display
      menu
      return
    end
    moves = board[row_col[0]][row_col[1]].potential_moves(board)
    potential_moves = {}
    moves.each do |move|
      potential_moves[move] = false
    end
    display(potential_moves)
    menu
  end
end

# Overload string
class String
  def colourise(white, move_to, capture_to)
    if move_to
      green_bg
    elsif capture_to
      red_bg
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

if __FILE__ == $PROGRAM_NAME
  game = Chess.new
  # game.display({ '00': false, '02': false })
  game.display
  game.menu
  game.show_potential_moves('A2')
  game.show_potential_moves('H2')
  game.show_potential_moves('I2')
end
