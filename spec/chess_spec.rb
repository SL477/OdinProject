# frozen_string_literal: true

require './ruby/chess'

describe Chess do
  it '#show_potential_moves black pawn start' do
    game = Chess.new
    row_col = game.get_row_column('H7')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board)
    expect(moves.length).to eq(2)
    result = moves.include?(:'74') && moves.include?(:'75')
    expect(result).to be true
  end
end
