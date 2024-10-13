# frozen_string_literal: true

require './ruby/tic_tac_toe'

describe TicTacToe do
  subject(:game) { described_class.new('X', 'O', %w[X X X 3 4 5 6 7 8], 'O', 'X') }

  it 'check_if_winner_found' do
    result = game.check_if_winner_found(game.board, game.x)
    expect(result).to be true
  end
end
