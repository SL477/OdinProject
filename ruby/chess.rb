# frozen_string_literal: true

require 'json'
require_relative 'lib/chess_piece'
require_relative 'lib/pawn'
require_relative 'lib/bishop'
require_relative 'lib/knight'
require_relative 'lib/rook'
require_relative 'lib/queen'
require_relative 'lib/king'
require_relative 'lib/chess_strings'

# Chess for the odin project
class Chess
  attr_accessor :board

  # def initialize # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  #   w = 'white'
  #   b = 'black'
  #   @board = [[Rook.new([0, 0], w), Knight.new([0, 1], w), Bishop.new([0, 2], w), Queen.new([0, 3], w),
  #              King.new([0, 4], w), Bishop.new([0, 5], w), Knight.new([0, 6], w), Rook.new([0, 7], w)]]
  #   white_pawn_row = (0..7).map { |i| Pawn.new([1, i], w) }
  #   @board.push(white_pawn_row)
  #   4.times do
  #     tmp = (0..7).map { nil }
  #     @board.push(tmp)
  #   end
  #   black_pawn_row = (0..7).map { |i| Pawn.new([6, i], b) }
  #   @board.push(black_pawn_row)
  #   @board.push([Rook.new([7, 0], b), Knight.new([7, 1], b), Bishop.new([7, 2], b), Queen.new([7, 3], b),
  #                King.new([7, 4], b), Bishop.new([7, 5], b), Knight.new([7, 6], b), Rook.new([7, 7], b)])
  #   @history = []
  #   @turn = 1
  # end

  def initialize(data)
    if data.key?(:'turn')
      @turn = data[:'turn']
      data.delete(:'turn')
    else
      @turn = 1
    end

    if data.key?(:'history')
      @history = data[:'history']
      data.delete(:'history')
    else
      @history = []
    end

    @board = []
    8.times do
      @board.push(Array.new(8))
    end

    data.each_key do |column_row|
      row_col = get_row_column(column_row)
      piece_data_str = data[column_row].to_s
      piece_data = JSON.load(piece_data_str)
      puts piece_data
      # puts piece_data['type']
      # puts piece_data.instance_of?(Hash)
      # puts piece_data.key?('type')
      # piece = case piece_data['type']
      # when 'bishop'
      #   Bishop.from_json(data[column_row])
      # when 'king'
      #   King.from_json(data[column_row])
      # when 'knight'
      #   Knight.from_json(data[column_row])
      # when 'queen'
      #   Queen.from_json(data[column_row])
      # when 'rook'
      #   Rook.from_json(data[column_row])
      # else
      #   Pawn.from_json(data[column_row])
      # end

      # @board[row_col[0]][row_col[1]] = piece
    end
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

  def to_row_column(row, column)
    if row < 0 || row > 7 || column < 0 || column > 7
      return false
    end

    columns = { 0 => 'a', 1 => 'b', 2 => 'c', 3 => 'd', 4 => 'e', 5 => 'f', 6 => 'g', 7 => 'h'}

    "#{columns[column]}#{row + 1}"
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

  def to_json
    obj = {turn: @turn, history: @history}
    (0..7).each do |row|
      (0..7).each do |column|
        if !@board[row][column].nil?
          obj[:"#{to_row_column(row, column)}"] = @board[row][column].to_json
        end
      end
    end
    JSON.dump(obj)
  end

  def self.from_json(string)
    data = JSON.load string
    self.new(data)
  end
end

if __FILE__ == $PROGRAM_NAME
  # game = Chess.new
  # # game.display({ '00': false, '02': false })
  # game.display
  # game.menu
  # game.show_potential_moves('A2')
  # game.show_potential_moves('H2')
  # game.show_potential_moves('H7')

  # puts game.to_json

  game = Chess.from_json('{"turn":2,"history":[],"a1":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"rook\"}","b1":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"knight\"}","c1":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"bishop\"}","d1":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"queen\"}","e1":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"king\"}","f1":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"bishop\"}","g1":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"knight\"}","h1":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"rook\"}","a2":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"pawn\"}","b2":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"pawn\"}","c2":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"pawn\"}","d2":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"pawn\"}","e2":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"pawn\"}","f2":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"pawn\"}","g2":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"pawn\"}","h2":"{\"moved\":false,\"alignment\":\"white\",\"type\":\"pawn\"}","a7":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"pawn\"}","b7":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"pawn\"}","c7":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"pawn\"}","d7":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"pawn\"}","e7":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"pawn\"}","f7":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"pawn\"}","g7":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"pawn\"}","h7":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"pawn\"}","a8":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"rook\"}","b8":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"knight\"}","c8":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"bishop\"}","d8":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"queen\"}","e8":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"king\"}","f8":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"bishop\"}","g8":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"knight\"}","h8":"{\"moved\":false,\"alignment\":\"black\",\"type\":\"rook\"}"}')
  game.display
end
