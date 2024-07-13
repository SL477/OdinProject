# rubocop:disable
$x = 'X'
$o = 'O'
$board = %w[0 1 2 3 4 5 6 7 8]

class TestPlayInfo
  attr_accessor :score, :index
  def initialize(score, index)
    @score = score
    @index = index
  end
end

def print_board
  (0..2).each do |i|
    puts '______'
    puts "|#{$board[(3 * i) + 0]}|#{$board[(3 * i) + 1]}|#{$board[(3 * i) + 2]}"
  end
  puts '______'
end

def all_empty_cells_indexes(current_board_state)
  current_board_state.select { |item| item != 'X' && item != 'O' }
end

def human_move
  is_valid = false
  human_move = ''
  until is_valid
    puts 'Chose an empty cell:'
    human_move = gets
    human_move = human_move.strip
    empty_cells = all_empty_cells_indexes($board)
    is_valid = empty_cells.include?(human_move)
  end
  human_move = Integer(human_move)
  $board[human_move] = $human_mark
end

def check_if_winner_found(current_board_state, current_mark)
  (current_board_state[0] == current_mark && current_board_state[1] == current_mark && current_board_state[2] == current_mark) || # rubocop:disable Layout/LineLength
    (current_board_state[3] == current_mark && current_board_state[4] == current_mark && current_board_state[5] == current_mark) || # rubocop:disable Layout/LineLength
    (current_board_state[6] == current_mark && current_board_state[7] == current_mark && current_board_state[8] == current_mark) || # rubocop:disable Layout/LineLength
    (current_board_state[0] == current_mark && current_board_state[3] == current_mark && current_board_state[6] == current_mark) || # rubocop:disable Layout/LineLength
    (current_board_state[1] == current_mark && current_board_state[4] == current_mark && current_board_state[7] == current_mark) || # rubocop:disable Layout/LineLength
    (current_board_state[2] == current_mark && current_board_state[5] == current_mark && current_board_state[8] == current_mark) || # rubocop:disable Layout/LineLength
    (current_board_state[0] == current_mark && current_board_state[4] == current_mark && current_board_state[8] == current_mark) || # rubocop:disable Layout/LineLength
    (current_board_state[2] == current_mark && current_board_state[4] == current_mark && current_board_state[6] == current_mark) # rubocop:disable Layout/LineLength
end

def mini_max(current_board_state_old, current_mark)
  current_board_state = current_board_state_old.map(&:clone)
  # step 8
  available_cells_indexes = all_empty_cells_indexes(current_board_state)

  # step 9, check if terminal state
  if check_if_winner_found(current_board_state, $human_mark)
    return TestPlayInfo.new(-1, -1)
  elsif check_if_winner_found(current_board_state, $ai_mark)
    return TestPlayInfo.new(1, -1)
  elsif available_cells_indexes.length == 0
    return TestPlayInfo.new(0, -1)
  end

  # step 10
  all_test_play_infos = []

  # step 11
  (0..(available_cells_indexes.length - 1)).each do |i|
    current_test_play_info = TestPlayInfo.new(0, current_board_state[Integer(available_cells_indexes[i])])
    current_board_state[Integer(available_cells_indexes[i])] = current_mark

    if (current_mark == $ai_mark)
      result = mini_max(current_board_state, $human_mark)
      current_test_play_info.score = result.score
    else
      result = mini_max(current_board_state, $ai_mark)
      current_test_play_info.score = result.score
    end

    # step 12
    current_board_state[Integer(available_cells_indexes[i])] = current_test_play_info.index;

    all_test_play_infos.push(current_test_play_info)
  end

  # step 15
  best_test_play = 0

  # step 16
  if current_mark == $ai_mark
    best_score = -1000000000000000000000000000000000000000
    (0..(all_test_play_infos.length - 1)).each do |i|
      if all_test_play_infos[i].score > best_score 
        best_score = all_test_play_infos[i].score
        best_test_play = i   
      end
    end
  else
    best_score = 1000000000000000000000000000000000000000
    (0..(all_test_play_infos.length - 1)).each do |i|
      if all_test_play_infos[i].score < best_score 
        best_score = all_test_play_infos[i].score
        best_test_play = i   
      end
    end
  end

  # step 17
  return all_test_play_infos[best_test_play]
end

def run_game
  stop = false
  until stop

    human_move
    print_board

    available_cells_indexes = all_empty_cells_indexes($board)

    if check_if_winner_found($board, $human_mark)
      puts 'You won!'
      stop = true
      return
    elsif available_cells_indexes.length <= 0
      puts 'Draw'
      stop = true
      return
    end

    ai_move = mini_max($board, $ai_mark)
    
    if Integer(ai_move.index) > -1 && ($board[Integer(ai_move.index)] != $x && $board[Integer(ai_move.index)] != $o) 
      $board[Integer(ai_move.index)] = $ai_mark
    else
      $board[Integer(available_cells_indexes[0])] = $ai_mark
    end
    print_board

    available_cells_indexes = all_empty_cells_indexes($board)

    if check_if_winner_found($board, $ai_mark)
      puts 'You lost!'
      stop = true
      return
    elsif available_cells_indexes.length <= 0
      puts 'Draw'
      stop = true
      return
    end
  end
end

puts 'Choose whether you would like to play as X or O:'
$human_mark = gets
$human_mark = $human_mark.strip()

if $human_mark.downcase == 'x'
  $ai_mark = $o
  $human_mark = $x
else
  $ai_mark = $x
  $human_mark = $o
end

puts "Human: #{$human_mark}, AI: #{$ai_mark}"
print_board
run_game

# rubocop:enable