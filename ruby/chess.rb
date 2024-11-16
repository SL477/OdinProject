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
class Chess # rubocop:disable Metrics/ClassLength
  attr_accessor :board

  def default_board # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    w = 'white'
    b = 'black'
    ret = [[Rook.new([0, 0], w), Knight.new([0, 1], w), Bishop.new([0, 2], w), Queen.new([0, 3], w),
            King.new([0, 4], w), Bishop.new([0, 5], w), Knight.new([0, 6], w), Rook.new([0, 7], w)]]
    ret.push((0..7).map { |i| Pawn.new([1, i], w) })
    4.times do
      ret.push(Array.new(8))
    end
    ret.push((0..7).map { |i| Pawn.new([6, i], b) })
    ret.push([Rook.new([7, 0], b), Knight.new([7, 1], b), Bishop.new([7, 2], b), Queen.new([7, 3], b),
              King.new([7, 4], b), Bishop.new([7, 5], b), Knight.new([7, 6], b), Rook.new([7, 7], b)])
    ret
  end

  def initialize(data = { 'turn' => 1, 'history' => [] }) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity
    @turn = data['turn']
    data.delete('turn')
    @history = data['history']
    data.delete('history')

    if data.count <= 0
      @board = default_board
    else
      @board = []
      8.times do
        @board.push(Array.new(8))
      end

      data.each_key do |column_row|
        row_col = get_row_column(column_row)
        piece_data_str = data[column_row].to_s
        piece_data = JSON.parse(piece_data_str)
        piece = case piece_data['type']
                when 'bishop'
                  Bishop.from_json(data[column_row])
                when 'king'
                  King.from_json(data[column_row])
                when 'knight'
                  Knight.from_json(data[column_row])
                when 'queen'
                  Queen.from_json(data[column_row])
                when 'rook'
                  Rook.from_json(data[column_row])
                else
                  Pawn.from_json(data[column_row])
                end
        piece.moved = piece_data['moved']
        @board[row_col[0]][row_col[1]] = piece
      end
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

  def menu # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    puts '1 - Make move. E.g. 1 A2 A4'
    puts '2 - Show moves. E.g 2 A2'
    puts '3 - Save'
    puts '4 - Show history'
    puts '5 - Load'

    input = gets
    input = input.strip
    arr = input.split
    if input == '3'
      File.open('save.json', 'w') do |file|
        file.puts to_json
      end
    elsif input == '5'
      initialize(JSON.parse(File.read('save.json').strip))
      display
      menu
    elsif input.start_with?('2') && arr.length > 1
      show_potential_moves(arr[1])
    elsif input.start_with?('1') && arr.length == 3
      make_move(arr[1], arr[2])
    else
      puts 'Invalid option'
      display
      menu
    end
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
    return false if row.negative? || row > 7 || column.negative? || column > 7

    columns = { 0 => 'a', 1 => 'b', 2 => 'c', 3 => 'd', 4 => 'e', 5 => 'f', 6 => 'g', 7 => 'h' }

    "#{columns[column]}#{row + 1}"
  end

  def show_potential_moves(column_row) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    row_col = get_row_column(column_row)
    if !row_col || board[row_col[0]][row_col[1]].nil?
      puts 'Invalid cell'
      display
      menu
      return
    end
    moves = board[row_col[0]][row_col[1]].potential_moves(board)
    potential_moves = {}
    moves.each do |move|
      potential_moves[move[0]] = move[1]
    end
    display(potential_moves)
    menu
  end

  def to_json(*_args)
    obj = { turn: @turn, history: @history }
    (0..7).each do |row|
      (0..7).each do |column|
        obj[:"#{to_row_column(row, column)}"] = @board[row][column].to_json unless @board[row][column].nil?
      end
    end
    JSON.dump(obj)
  end

  def self.from_json(string)
    data = JSON.parse(string)
    new(data)
  end

  def make_move(origin, destination)
    row_col_origin = get_row_column(origin)
    row_col_destination = get_row_column(destination)
    if !row_col_origin || board[row_col_origin[0]][row_col_origin[1]].nil? || !row_col_destination
      puts 'Invalid cell or destination'
      display
      menu
      return
    end

    # get potential moves
    moves = board[row_col_origin[0]][row_col_origin[1]].potential_moves(board)

    # turn destination into Column-Row
    destination_col_row = :"#{row_col_destination[1]}#{row_col_destination[0]}"

    potential_moves = {}
    moves.each do |move|
      potential_moves[move[0]] = move[1]
    end

    if !potential_moves.key?(destination_col_row)
      puts 'Invalid destination'
      display
      menu
      return
    end
    
    @board = board[row_col_origin[0]][row_col_origin[1]].preview_move([destination_col_row, potential_moves[destination_col_row]], board)

    # TODO: computer move and add to history

    @turn += 1
    display
    menu
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Chess.new
  # game.display({ '00': false, '02': false })
  game.display
  game.menu
  # game.show_potential_moves('A2')
  # game.show_potential_moves('H2')
  # game.show_potential_moves('H7')
  # game.show_potential_moves('A3')

  # puts game.to_json

  # game = Chess.from_json('{"turn":2,"history":[],"a1":"{\"moved\":false,\"location\":[0,0],\"points\":5,\"alignment\":\"white\",\"notation\":\"R\",\"picture\":\"♖\",\"type\":\"rook\"}","b1":"{\"moved\":false,\"location\":[0,1],\"points\":3,\"alignment\":\"white\",\"notation\":\"N\",\"picture\":\"♘\",\"type\":\"knight\"}","c1":"{\"moved\":false,\"location\":[0,2],\"points\":3,\"alignment\":\"white\",\"notation\":\"B\",\"picture\":\"♗\",\"type\":\"bishop\"}","d1":"{\"moved\":false,\"location\":[0,3],\"points\":9,\"alignment\":\"white\",\"notation\":\"Q\",\"picture\":\"♕\",\"type\":\"queen\"}","e1":"{\"moved\":false,\"location\":[0,4],\"points\":100,\"alignment\":\"white\",\"notation\":\"K\",\"picture\":\"♔\",\"type\":\"king\"}","f1":"{\"moved\":false,\"location\":[0,5],\"points\":3,\"alignment\":\"white\",\"notation\":\"B\",\"picture\":\"♗\",\"type\":\"bishop\"}","g1":"{\"moved\":false,\"location\":[0,6],\"points\":3,\"alignment\":\"white\",\"notation\":\"N\",\"picture\":\"♘\",\"type\":\"knight\"}","h1":"{\"moved\":false,\"location\":[0,7],\"points\":5,\"alignment\":\"white\",\"notation\":\"R\",\"picture\":\"♖\",\"type\":\"rook\"}","a2":"{\"moved\":false,\"location\":[1,0],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","b2":"{\"moved\":false,\"location\":[1,1],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","c2":"{\"moved\":false,\"location\":[1,2],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","d2":"{\"moved\":false,\"location\":[1,3],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","e2":"{\"moved\":false,\"location\":[1,4],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","f2":"{\"moved\":false,\"location\":[1,5],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","g2":"{\"moved\":false,\"location\":[1,6],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","h2":"{\"moved\":false,\"location\":[1,7],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","a7":"{\"moved\":false,\"location\":[6,0],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","b7":"{\"moved\":false,\"location\":[6,1],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","c7":"{\"moved\":false,\"location\":[6,2],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","d7":"{\"moved\":false,\"location\":[6,3],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","e7":"{\"moved\":false,\"location\":[6,4],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","f7":"{\"moved\":false,\"location\":[6,5],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","g7":"{\"moved\":false,\"location\":[6,6],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","h7":"{\"moved\":false,\"location\":[6,7],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","a8":"{\"moved\":false,\"location\":[7,0],\"points\":5,\"alignment\":\"black\",\"notation\":\"R\",\"picture\":\"♜\",\"type\":\"rook\"}","b8":"{\"moved\":false,\"location\":[7,1],\"points\":3,\"alignment\":\"black\",\"notation\":\"N\",\"picture\":\"♞\",\"type\":\"knight\"}","c8":"{\"moved\":false,\"location\":[7,2],\"points\":3,\"alignment\":\"black\",\"notation\":\"B\",\"picture\":\"♝\",\"type\":\"bishop\"}","d8":"{\"moved\":false,\"location\":[7,3],\"points\":9,\"alignment\":\"black\",\"notation\":\"Q\",\"picture\":\"♛\",\"type\":\"queen\"}","e8":"{\"moved\":false,\"location\":[7,4],\"points\":100,\"alignment\":\"black\",\"notation\":\"K\",\"picture\":\"♚\",\"type\":\"king\"}","f8":"{\"moved\":false,\"location\":[7,5],\"points\":3,\"alignment\":\"black\",\"notation\":\"B\",\"picture\":\"♝\",\"type\":\"bishop\"}","g8":"{\"moved\":false,\"location\":[7,6],\"points\":3,\"alignment\":\"black\",\"notation\":\"N\",\"picture\":\"♞\",\"type\":\"knight\"}","h8":"{\"moved\":false,\"location\":[7,7],\"points\":5,\"alignment\":\"black\",\"notation\":\"R\",\"picture\":\"♜\",\"type\":\"rook\"}"}')
  # game.display
end
