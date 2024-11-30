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
require_relative 'lib/test_play_info'

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

  def display(potential_moves = {}, org_moves = {}) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    # pp @board
    puts "Turn - #{@turn}"
    white = true
    (0..7).reverse_each do |row|
      white = row.odd?
      row_word = "#{row + 1} "
      @board[row].each_with_index do |cell, col|
        row_word += if cell.nil?
                      '    '.colourise(white, potential_moves.key?(:"#{col}#{row}"), false, false)
                    else
                      " #{cell.picture}  ".colour_in(cell.alignment).colourise(white, false,
                                                                               potential_moves.key?(:"#{col}#{row}"),
                                                                               org_moves.key?(:"#{col}#{row}"))
                    end
        white = !white
      end
      puts row_word
    end
    puts '    A   B   C   D   E   F   G   H'
  end

  def menu # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    puts '1 - Make move. E.g. 1 A2 A4'
    puts '2 - Show moves. E.g 2 A2'
    puts '3 - Save'
    puts '4 - Show history'
    puts '5 - Load'
    puts '6 - Get hint'
    # Done: Show moves, show all moves. Show history. Give a hint for the next move

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
    elsif input.start_with?('2')
      show_all_potential_moves
    elsif input.start_with?('1') && arr.length == 3
      make_move(arr[1], arr[2])
    elsif input == '6'
      begin
        best_move = mini_max(@board, 'white')
      rescue SystemStackError
        best_move = random_move(@board, 'white')
      end
      # puts best_move
      # puts best_move.score
      # puts best_move.index
      display
      # puts best_move.index
      best_split = best_move.index.split('-')
      org = to_row_column(best_split[0][1].to_i, best_split[0][0].to_i).upcase
      dest = to_row_column(best_split[1][4].to_i, best_split[1][3].to_i).upcase
      puts "Hint: #{org} #{dest}"
      menu
    elsif input == '4'
      display
      show_history
      menu
    else
      puts 'Invalid option'
      display
      menu
    end
  end

  def show_history
    puts 'History:'
    @history.each do |move|
      puts "#{move[0]} - #{move[1].upcase} - #{move[2].upcase}"
    end
    puts 'Menu:'
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
    # DONE: human should not be able to put themselves in check/leave themself in check
    row_col = get_row_column(column_row)
    if !row_col || board[row_col[0]][row_col[1]].nil?
      puts 'Invalid cell'
      display
      menu
      return
    end
    moves = board[row_col[0]][row_col[1]].potential_moves_with_check_check(board)
    # potential_moves(board)
    potential_moves = {}
    moves.each do |move|
      potential_moves[move[0]] = move[1]
    end
    origins = { "#{row_col[1]}#{row_col[0]}": false }
    display(potential_moves, origins)
    menu
  end

  def show_all_potential_moves # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    current_side = board.flatten.compact.select { |cell| cell.alignment == 'white' }
    potential_moves = {}
    origins = {}
    current_side.each do |piece|
      moves = piece.potential_moves_with_check_check(board)
      origins[:"#{piece.location[1]}#{piece.location[0]}"] = false if moves.length.positive?
      moves.each do |move|
        potential_moves[move[0]] = move[1]
      end
    end
    display(potential_moves, origins)
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

  def make_move(origin, destination) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    row_col_origin = get_row_column(origin)
    row_col_destination = get_row_column(destination)
    selected_cell = board[row_col_origin[0]][row_col_origin[1]]
    if !row_col_origin || selected_cell.nil? || !row_col_destination || selected_cell.alignment == 'black'
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

    unless potential_moves.key?(destination_col_row)
      puts 'Invalid destination'
      display
      menu
      return
    end

    new_board = board[row_col_origin[0]][row_col_origin[1]].preview_move(
      [destination_col_row, potential_moves[destination_col_row]], board
    ) # [0]

    # Add to history
    white_move = get_algebraic_notation(@board, row_col_origin, new_board,
                                        [destination_col_row, potential_moves[destination_col_row]])
    @history.push([@turn.to_s, white_move, ''])
    @board = new_board

    # Done: add to history
    first_piece = @board.flatten.compact[0]
    if first_piece.in_check?(@board, 'black') && first_piece.in_checkmate?(@board, 'black')
      display
      puts 'You won!'
      @history.push([@turn.to_s, '1-0', ''])
      return
    end

    begin
      need_check_check = true
      best_move = mini_max(@board, 'black')
      if best_move.index == -1
        need_check_check = false
        best_move = random_move(@board, 'black')
      end
    rescue SystemStackError
      need_check_check = false
      best_move = random_move(@board, 'black')
    end

    if best_move.nil?
      display
      puts 'Draw!'
      @history.push([@turn.to_s, '1/2', '1/2'])
      return
    end
    best_split = best_move.index.split('-')
    # puts "best_move: #{best_move.index}"
    ai_move = [best_split[1][3..4].to_sym, best_split[1][9..-3]]
    ai_move[1] = nil if best_split[1][8..-2] == 'nil'
    # puts "ai_move: #{ai_move}"
    new_board = @board[best_split[0][1].to_i][best_split[0][0].to_i].preview_move(ai_move, @board)

    if need_check_check && new_board.flatten.compact.select do |piece|
                             piece.alignment == 'black'
                           end[0].in_check?(new_board)
      best_move = random_move(@board, 'black')
      if best_move.nil?
        display
        puts 'Draw!'
        @history.push([@turn.to_s, '1/2', '1/2'])
        return
      end
      # puts "best_move: #{best_move.index}"
      best_split = best_move.index.split('-')
      ai_move = [best_split[1][3..4].to_sym, best_split[1][9..-3]]
      ai_move[1] = nil if best_split[1][8..-2] == 'nil'
      # puts "ai_move: #{ai_move}"
      new_board = @board[best_split[0][1].to_i][best_split[0][0].to_i].preview_move(ai_move, @board)
    end

    # Add to history
    black_move = get_algebraic_notation(@board, [best_split[0][1].to_i, best_split[0][0].to_i], new_board, ai_move)
    @history[-1][2] = black_move
    @board = new_board

    first_piece = @board.flatten.compact[0]
    if first_piece.in_check?(@board, 'white') && first_piece.in_checkmate?(@board, 'white')
      display
      puts 'You lost!'
      @history.push([@turn.to_s, '0-1', ''])
      return
    elsif first_piece.in_checkmate?(@board, 'white')
      display
      puts 'Draw!'
      @history.push([@turn.to_s, '1/2', '1/2'])
      return
    end

    @turn += 1
    display
    menu
  end

  def mini_max(current_board_state_old, current_alignment, depth = 3) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    current_board_state = current_board_state_old.map { |row| row.map(&:dup) }
    other_alignment = if current_alignment == 'white'
                        'black'
                      else
                        'white'
                      end

    # step 8
    available_moves = {}
    current_side_pieces = current_board_state.flatten.select do |cell|
      !cell.nil? && cell.alignment == current_alignment
    end

    is_check = current_side_pieces[0].in_check?(current_board_state)

    current_side_pieces.each do |piece|
      moves = if is_check
                piece.potential_moves_with_check_check(current_board_state)
              else
                piece.potential_moves(current_board_state)
              end
      available_moves[piece] = moves if moves.length.positive?
    end

    # step 9, check if terminal state
    first_piece = current_board_state.flatten.compact[0]
    if first_piece.in_check?(current_board_state,
                             current_alignment) && first_piece.in_checkmate?(current_board_state, current_alignment)
      return TestPlayInfo.new(-1_000_000, -1)
    elsif first_piece.in_check?(current_board_state,
                                other_alignment) && first_piece.in_checkmate?(current_board_state, other_alignment)
      return TestPlayInfo.new(1_000_000, -1)
    elsif available_moves.count <= 0
      return TestPlayInfo.new(0, -1)
    elsif depth <= 0
      current_side_score = 139
      current_side_pieces.each do |piece|
        current_side_score += piece.points
      end
      other_side_pieces = current_board_state.flatten.select { |cell| !cell.nil? && cell.alignment == other_alignment }
      other_side_pieces.each do |piece|
        current_side_score -= piece.points
      end
      return TestPlayInfo.new(current_side_score, -1)
    end

    # Step 10
    all_test_play_infos = []

    # Step 11
    # pp available_moves
    # puts 'start'
    available_moves.each_key do |piece|
      piece_moves = available_moves[piece]
      # pp piece
      # location = [piece.location[0], piece.location[1]]
      # moved = piece.moved
      piece_moves.each do |move|
        # piece.moved = moved
        # piece.location = location/
        # puts 'piece location'
        # pp piece.location
        # puts 'end piece location'
        # pp move
        current_test_play_info = TestPlayInfo.new(0, "#{piece.location[1]}#{piece.location[0]}-#{move}")
        new_state = piece.preview_move(move, current_board_state)
        result = mini_max(new_state, other_alignment, depth - 1)
        current_test_play_info.score = result.score
        # Step 12
        all_test_play_infos.push(current_test_play_info)
      end
    end

    # Step 15
    best_test_play = 0
    if current_alignment == 'black'
      best_score = -1_000_000_000_000
      (0..(all_test_play_infos.length - 1)).each do |i|
        if all_test_play_infos[i].score > best_score
          best_score = all_test_play_infos[i].score
          best_test_play = i
        end
      end
    else
      best_score = 1_000_000_000_000
      (0..(all_test_play_infos.length - 1)).each do |i|
        if all_test_play_infos[i].score < best_score
          best_score = all_test_play_infos[i].score
          best_test_play = i
        end
      end
    end

    # Step 17
    all_test_play_infos[best_test_play]
  end

  def get_algebraic_notation(org_board, origin, new_board, move) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
    return move[1].split('_')[1] if !move[1].nil? && move[1].start_with?('castle')

    # Check for check
    org_piece = org_board[origin[0]][origin[1]]

    other_side = if org_piece.alignment == 'white'
                   'black'
                 else
                   'white'
                 end
    is_check = org_piece.in_check?(new_board, other_side)
    is_checkmate = is_check && org_piece.in_checkmate?(new_board, other_side)

    # Check for captures
    start_opponent_pieces = org_board.flatten.compact.select { |cell| cell.alignment == other_side }.length
    end_opponent_pieces = new_board.flatten.compact.select { |cell| cell.alignment == other_side }.length
    captured = if end_opponent_pieces < start_opponent_pieces
                 'x'
               else
                 ''
               end

    # Disambiguation
    other_pieces = org_board.flatten.compact.select do |cell|
      cell.alignment == org_piece.alignment && cell.type == org_piece.type &&
        !(cell.location[0] == org_piece.location[0] && cell.location[1] == org_piece.location[1])
    end
    other_pieces_locations = []
    other_pieces.each do |piece|
      potential_moves = piece.potential_moves(org_board)
      potential_moves.each do |potential_move|
        other_pieces_locations.push(piece.location) if potential_move[0] == move[0]
      end
    end

    if other_pieces_locations.length > 1
      disambiguation = to_row_column(org_piece.location[0], org_piece.location[1])
    elsif other_pieces_locations.length == 1 && other_pieces_locations[0][1] == org_piece.location[1] # rubocop:disable Lint/DuplicateBranch
      disambiguation = to_row_column(org_piece.location[0], org_piece.location[1])
    elsif other_pieces_locations.length == 1 || captured == 'x'
      disambiguation = to_row_column(org_piece.location[0], org_piece.location[1])[0]
    else
      disambiguation = ''
    end

    notation = org_piece.notation
    destination = move[0].to_s.chars
    destination = to_row_column(destination[1].to_i, destination[0].to_i)
    special = if is_checkmate
                '#'
              elsif is_check
                '+'
              else
                ''
              end

    notation + disambiguation + captured + destination + special
  end

  def random_move(current_board_state, current_alignment) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    current_side_pieces = current_board_state.flatten.select do |cell|
      !cell.nil? && cell.alignment == current_alignment
    end

    # Pick a random piece, then a random move
    potential_moves = {}
    current_side_pieces.each do |piece|
      moves = piece.potential_moves_with_check_check(current_board_state)

      potential_moves[piece] = moves if moves.length.positive?
    end
    return nil if potential_moves.keys.length <= 0

    selected_piece = potential_moves.keys.sample
    TestPlayInfo.new(0,
                     "#{selected_piece.location[1]}#{selected_piece.location[0]}-#{potential_moves[selected_piece].sample}") # rubocop:disable Layout/LineLength
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

  # game = Chess.from_json('{"turn":2,"history":[],"a1":"{\"moved\":false,\"location\":[0,0],\"points\":5,\"alignment\":\"white\",\"notation\":\"R\",\"picture\":\"♖\",\"type\":\"rook\"}","b1":"{\"moved\":false,\"location\":[0,1],\"points\":3,\"alignment\":\"white\",\"notation\":\"N\",\"picture\":\"♘\",\"type\":\"knight\"}","c1":"{\"moved\":false,\"location\":[0,2],\"points\":3,\"alignment\":\"white\",\"notation\":\"B\",\"picture\":\"♗\",\"type\":\"bishop\"}","d1":"{\"moved\":false,\"location\":[0,3],\"points\":9,\"alignment\":\"white\",\"notation\":\"Q\",\"picture\":\"♕\",\"type\":\"queen\"}","e1":"{\"moved\":false,\"location\":[0,4],\"points\":100,\"alignment\":\"white\",\"notation\":\"K\",\"picture\":\"♔\",\"type\":\"king\"}","f1":"{\"moved\":false,\"location\":[0,5],\"points\":3,\"alignment\":\"white\",\"notation\":\"B\",\"picture\":\"♗\",\"type\":\"bishop\"}","g1":"{\"moved\":false,\"location\":[0,6],\"points\":3,\"alignment\":\"white\",\"notation\":\"N\",\"picture\":\"♘\",\"type\":\"knight\"}","h1":"{\"moved\":false,\"location\":[0,7],\"points\":5,\"alignment\":\"white\",\"notation\":\"R\",\"picture\":\"♖\",\"type\":\"rook\"}","a2":"{\"moved\":false,\"location\":[1,0],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","b2":"{\"moved\":false,\"location\":[1,1],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","c2":"{\"moved\":false,\"location\":[1,2],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","d2":"{\"moved\":false,\"location\":[1,3],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","e2":"{\"moved\":false,\"location\":[1,4],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","f2":"{\"moved\":false,\"location\":[1,5],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","g2":"{\"moved\":false,\"location\":[1,6],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","h2":"{\"moved\":false,\"location\":[1,7],\"points\":1,\"alignment\":\"white\",\"notation\":\"\",\"picture\":\"♙\",\"type\":\"pawn\"}","a7":"{\"moved\":false,\"location\":[6,0],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","b7":"{\"moved\":false,\"location\":[6,1],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","c7":"{\"moved\":false,\"location\":[6,2],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","d7":"{\"moved\":false,\"location\":[6,3],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","e7":"{\"moved\":false,\"location\":[6,4],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","f7":"{\"moved\":false,\"location\":[6,5],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","g7":"{\"moved\":false,\"location\":[6,6],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","h7":"{\"moved\":false,\"location\":[6,7],\"points\":1,\"alignment\":\"black\",\"notation\":\"\",\"picture\":\"♟\",\"type\":\"pawn\"}","a8":"{\"moved\":false,\"location\":[7,0],\"points\":5,\"alignment\":\"black\",\"notation\":\"R\",\"picture\":\"♜\",\"type\":\"rook\"}","b8":"{\"moved\":false,\"location\":[7,1],\"points\":3,\"alignment\":\"black\",\"notation\":\"N\",\"picture\":\"♞\",\"type\":\"knight\"}","c8":"{\"moved\":false,\"location\":[7,2],\"points\":3,\"alignment\":\"black\",\"notation\":\"B\",\"picture\":\"♝\",\"type\":\"bishop\"}","d8":"{\"moved\":false,\"location\":[7,3],\"points\":9,\"alignment\":\"black\",\"notation\":\"Q\",\"picture\":\"♛\",\"type\":\"queen\"}","e8":"{\"moved\":false,\"location\":[7,4],\"points\":100,\"alignment\":\"black\",\"notation\":\"K\",\"picture\":\"♚\",\"type\":\"king\"}","f8":"{\"moved\":false,\"location\":[7,5],\"points\":3,\"alignment\":\"black\",\"notation\":\"B\",\"picture\":\"♝\",\"type\":\"bishop\"}","g8":"{\"moved\":false,\"location\":[7,6],\"points\":3,\"alignment\":\"black\",\"notation\":\"N\",\"picture\":\"♞\",\"type\":\"knight\"}","h8":"{\"moved\":false,\"location\":[7,7],\"points\":5,\"alignment\":\"black\",\"notation\":\"R\",\"picture\":\"♜\",\"type\":\"rook\"}"}') # rubocop:disable Layout/LineLength
  # game.display
end
