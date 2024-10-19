# frozen_string_literal: true

# To play connect four on the command line
class ConnectFour # rubocop:disable Metrics/ClassLength
  attr_reader :board, :red_circle, :blue_circle

  def initialize # rubocop:disable Metrics/MethodLength
    @empty_cell = "\u{1F518}"
    @red_circle = "\u{1F534}"
    @blue_circle = "\u{1F535}"
    @board = []
    6.times do
      tmp = []
      7.times do
        tmp.push(@empty_cell)
      end
      @board.push(tmp)
    end
  end

  def display
    (0..5).each do |row|
      puts @board[row].join
    end
  end

  def add_counter(column, token_counter) # rubocop:disable Metrics/MethodLength
    # put on the lowest level
    return false if column.negative? || column > 6

    return false if @board[0][column] != @empty_cell

    # find first empty level
    level = 0
    stop = false
    until stop
      if @board[level][column] == @empty_cell
        level += 1
        if level == 6
          level = 5
          stop = true
        end
      else
        stop = true
        level -= 1
      end
    end

    @board[level][column] = token_counter
    @board
  end

  def check_if_winner_found # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    # check horizontal
    @board.each do |row|
      check = check_if_winner_found_horizontal(row)
      return check if check
    end

    # check vertical
    (0..6).each do |col|
      tmp = (0..5).map do |row|
        @board[row][col]
      end
      check = check_if_winner_found_horizontal(tmp)
      return check if check
    end

    # check diagonals
    left_diagonals = [[3, 0], [4, 0], [5, 0], [5, 1], [5, 2], [5, 3]]
    left_diagonals.each do |start|
      col = start[1]
      row = start[0]
      tmp = []
      stop = false
      until stop
        if row.negative? || col > 6
          stop = true
        else
          tmp.push(@board[row][col])
          row -= 1
          col += 1
        end
      end
      check = check_if_winner_found_horizontal(tmp)
      return check if check
    end

    right_diagonals = [[2, 0], [1, 0], [0, 0], [0, 1], [0, 2], [0, 3]]
    right_diagonals.each do |start|
      col = start[1]
      row = start[0]
      tmp = []
      stop = false
      until stop
        if col > 6 || row > 5
          stop = true
        else
          tmp.push(@board[row][col])
          row += 1
          col += 1
        end
      end
      check = check_if_winner_found_horizontal(tmp)
      return check if check
    end
    false
  end

  def check_if_winner_found_horizontal(row)
    last = ''
    cnt = 0
    row.each do |cell|
      last = cell if last == ''

      cnt += 1 if cell == last && cell != @empty_cell

      return last if cnt >= 4

      cnt = 1 if cell != last
      last = cell
    end
    false
  end

  def number_or_minus1(string)
    Integer(string || '')
  rescue ArgumentError
    -1
  end

  def get_player_input(player) # rubocop:disable Metrics/MethodLength
    stop = false
    until stop
      puts "Player #{player} pick a column"
      choice = gets
      choice = choice.strip
      choice = number_or_minus1(choice)
      counter_token = if player == 1
                        red_circle
                      else
                        blue_circle
                      end
      stop = true if add_counter(choice, counter_token)
    end
    display
  end

  def check_if_board_full
    @board[0].each do |cell|
      return false if cell == @empty_cell
    end
    true
  end

  def play # rubocop:disable Metrics/MethodLength
    display
    stop = false
    until stop
      get_player_input(1)
      if check_if_winner_found
        stop = true
        puts 'Player 1 wins!'
      elsif check_if_board_full
        stop = true
        puts 'Draw!'
      else
        get_player_input(2)
        if check_if_winner_found
          stop = true
          puts 'Player 2 wins!'
        elsif check_if_board_full
          stop = true
          puts 'Draw!'
        end
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  game = ConnectFour.new
  game.play
end
