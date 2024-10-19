# frozen_string_literal: true

require './ruby/connect_four'

describe ConnectFour do # rubocop:disable Metrics/BlockLength
  subject(:game) { described_class.new }
  subject(:game2) { described_class.new }
  subject(:game3) { described_class.new }
  subject(:game4) { described_class.new }
  subject(:game5) { described_class.new }

  it 'Adding counter' do
    result = game.add_counter(0, 'a')
    expect(result[5][0]).to eq('a')
  end

  it 'check winner' do
    result = game.check_if_winner_found
    expect(result).to be false
  end

  it 'check winner horizontal' do
    game2.add_counter(0, game2.red_circle)
    game2.add_counter(1, game2.red_circle)
    game2.add_counter(2, game2.red_circle)
    game2.add_counter(3, game2.red_circle)
    result = game2.check_if_winner_found
    expect(result).to eq(game2.red_circle)
  end

  it 'check winner vertical' do
    game3.add_counter(0, game3.red_circle)
    game3.add_counter(0, game3.red_circle)
    game3.add_counter(0, game3.red_circle)
    game3.add_counter(0, game3.red_circle)
    result = game3.check_if_winner_found
    expect(result).to eq(game3.red_circle)
  end

  it 'check winner diagonally' do
    game4.add_counter(0, game4.red_circle)
    game4.add_counter(1, '1')
    game4.add_counter(1, game4.red_circle)
    game4.add_counter(2, '2')
    game4.add_counter(2, '2')
    game4.add_counter(2, game4.red_circle)
    game4.add_counter(3, '3')
    game4.add_counter(3, '3')
    game4.add_counter(3, '3')
    game4.add_counter(3, game4.red_circle)
    result = game4.check_if_winner_found
    expect(result).to eq(game4.red_circle)
  end

  it 'check if board full (not)' do
    result = game.check_if_board_full
    expect(result).to be false
  end

  it 'check if board full (is)' do
    6.times do
      (0..6).each do |col|
        game5.add_counter(col, game5.red_circle)
      end
    end
    result = game5.check_if_board_full
    expect(result).to be true
  end
end
