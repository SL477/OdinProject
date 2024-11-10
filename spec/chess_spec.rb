# frozen_string_literal: true

require './ruby/chess'

describe Chess do # rubocop:disable Metrics/BlockLength
  it '#show_potential_moves black pawn start' do
    game = Chess.new
    row_col = game.get_row_column('H7')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board).flatten.compact
    expect(moves.length).to eq(2)
    result = moves.include?(:'74') && moves.include?(:'75')
    expect(result).to be true
  end

  it '#show_potential_moves white pawn start' do
    game = Chess.new
    row_col = game.get_row_column('H2')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board).flatten.compact
    expect(moves.length).to eq(2)
    result = moves.include?(:'72') && moves.include?(:'73')
    expect(result).to be true
  end

  it 'En passant white' do
    game = Chess.new({
                       'turn' => 2,
                       'history' => ['1 - c5 - b5'],
                       'b5' => '{"moved":true,"location":[4,1],"points":1,"alignment":"black","notation":"","picture":"♟","type":"pawn","en_passant":true}', # rubocop:disable Layout/LineLength
                       'c5' => '{"moved":true,"location":[4,2],"points":1,"alignment":"white","notation":"","picture":"♙","type":"pawn"}' # rubocop:disable Layout/LineLength
                     })
    row_col = game.get_row_column('C5')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board).flatten.compact.reject do |move|
      move == 'enPassant'
    end
    expect(moves.length).to eq(2)
    result = moves.include?(:'25') && moves.include?(:'15')
    expect(result).to be true
  end

  it 'White Knight B1' do
    game = Chess.new
    row_col = game.get_row_column('B1')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board).flatten.compact
    expect(moves.length).to eq(2)
    result = moves.include?(:'02') && moves.include?(:'22')
    expect(result).to be true
  end

  it 'Bishop on Black C5' do
    game = Chess.new({ 'c5' => '{"moved":true,"location":[4,2],"points":1,"alignment":"white","notation":"b","picture":"♙","type":"bishop"}' }) # rubocop:disable Layout/LineLength
    row_col = game.get_row_column('C5')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board).flatten.compact
    expect(moves.length).to eq(11)
    result = moves.include?(:'06')
    # pp moves
    expect(result).to be true
  end

  it 'Queen on Black C5' do
    game = Chess.new({ 'c5' => '{"moved":true,"location":[4,2],"points":1,"alignment":"white","notation":"b","picture":"♙","type":"queen"}' }) # rubocop:disable Layout/LineLength
    row_col = game.get_row_column('C5')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board).flatten.compact
    expect(moves.length).to eq(25)
    result = moves.include?(:'06')
    # pp moves
    expect(result).to be true
  end

  it 'Rook on Black C5' do
    game = Chess.new({ 'c5' => '{"moved":true,"location":[4,2],"points":1,"alignment":"white","notation":"b","picture":"♙","type":"rook"}' }) # rubocop:disable Layout/LineLength
    row_col = game.get_row_column('C5')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board).flatten.compact
    expect(moves.length).to eq(14)
    result = moves.include?(:'04')
    # pp moves
    expect(result).to be true
  end

  it 'King on Black C5' do
    game = Chess.new({ 'c5' => '{"moved":true,"location":[4,2],"points":1,"alignment":"white","notation":"b","picture":"♙","type":"king"}' }) # rubocop:disable Layout/LineLength
    row_col = game.get_row_column('C5')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board).flatten.compact
    expect(moves.length).to eq(4)
    result = moves.include?(:'14')
    # pp moves
    expect(result).to be true
  end

  it 'Is King in check? False' do
    game = Chess.new({ 'c5' => '{"moved":true,"location":[4,2],"points":1,"alignment":"white","notation":"b","picture":"♙","type":"king"}' }) # rubocop:disable Layout/LineLength
    row_col = game.get_row_column('C5')
    in_check = game.board[row_col[0]][row_col[1]].in_check?(game.board)
    expect(in_check).to be false
  end

  it 'Is King in check? True' do
    game = Chess.new({ 'c5' => '{"moved":true,"location":[4,2],"points":1,"alignment":"white","notation":"b","picture":"♙","type":"king"}', # rubocop:disable Layout/LineLength
                       'd5' => '{"moved":true,"location":[4,3],"points":1,"alignment":"black","notation":"b","picture":"♙","type":"queen"}' }) # rubocop:disable Layout/LineLength
    row_col = game.get_row_column('C5')
    in_check = game.board[row_col[0]][row_col[1]].in_check?(game.board)
    expect(in_check).to be true
  end

  it 'Can castle right' do
    game = Chess.new({
                       'a1' => '{"moved":false,"location":[0,0],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e1' => '{"moved":false,"location":[0,4],"points":100,"alignment":"white","notation":"K","picture":"♔","type":"king","en_passant":false}', # rubocop:disable Layout/LineLength
                       'h1' => '{"moved":false,"location":[0,7],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e8' => '{"moved":false,"location":[7,4],"points":100,"alignment":"black","notation":"K","picture":"♚","type":"king","en_passant":false}' # rubocop:disable Layout/LineLength
                     })
    row_col = game.get_row_column('H1')
    # moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board)
    can_castle = game.board[row_col[0]][row_col[1]].can_castle?(game.board)
    expect(can_castle).to be true
  end

  it 'Can castle left' do
    game = Chess.new({
                       'a1' => '{"moved":false,"location":[0,0],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e1' => '{"moved":false,"location":[0,4],"points":100,"alignment":"white","notation":"K","picture":"♔","type":"king","en_passant":false}', # rubocop:disable Layout/LineLength
                       'h1' => '{"moved":false,"location":[0,7],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e8' => '{"moved":false,"location":[7,4],"points":100,"alignment":"black","notation":"K","picture":"♚","type":"king","en_passant":false}' # rubocop:disable Layout/LineLength
                     })
    row_col = game.get_row_column('A1')
    # moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board)
    can_castle = game.board[row_col[0]][row_col[1]].can_castle?(game.board)
    expect(can_castle).to be true
  end

  it 'Can castle left, false, items in way' do
    game = Chess.new
    row_col = game.get_row_column('A1')
    can_castle = game.board[row_col[0]][row_col[1]].can_castle?(game.board)
    expect(can_castle).to be false
  end

  it 'Can castle left in check, false' do
    game = Chess.new({
                       'a1' => '{"moved":false,"location":[0,0],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e1' => '{"moved":false,"location":[0,4],"points":100,"alignment":"white","notation":"K","picture":"♔","type":"king","en_passant":false}', # rubocop:disable Layout/LineLength
                       'h1' => '{"moved":false,"location":[0,7],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e8' => '{"moved":false,"location":[7,4],"points":100,"alignment":"black","notation":"K","picture":"♚","type":"rook","en_passant":false}' # rubocop:disable Layout/LineLength
                     })
    row_col = game.get_row_column('A1')
    can_castle = game.board[row_col[0]][row_col[1]].can_castle?(game.board)
    expect(can_castle).to be false
  end

  it 'Can castle left through check, false' do
    game = Chess.new({
                       'a1' => '{"moved":false,"location":[0,0],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e1' => '{"moved":false,"location":[0,4],"points":100,"alignment":"white","notation":"K","picture":"♔","type":"king","en_passant":false}', # rubocop:disable Layout/LineLength
                       'h1' => '{"moved":false,"location":[0,7],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'd8' => '{"moved":false,"location":[7,3],"points":100,"alignment":"black","notation":"K","picture":"♚","type":"rook","en_passant":false}' # rubocop:disable Layout/LineLength
                     })
    row_col = game.get_row_column('A1')
    can_castle = game.board[row_col[0]][row_col[1]].can_castle?(game.board)
    expect(can_castle).to be false
  end

  it 'Can castle left, has moved, false' do
    game = Chess.new({
                       'a1' => '{"moved":true,"location":[0,0],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e1' => '{"moved":false,"location":[0,4],"points":100,"alignment":"white","notation":"K","picture":"♔","type":"king","en_passant":false}', # rubocop:disable Layout/LineLength
                       'h1' => '{"moved":false,"location":[0,7],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e8' => '{"moved":false,"location":[7,4],"points":100,"alignment":"black","notation":"K","picture":"♚","type":"king","en_passant":false}' # rubocop:disable Layout/LineLength
                     })
    row_col = game.get_row_column('A1')
    can_castle = game.board[row_col[0]][row_col[1]].can_castle?(game.board)
    expect(can_castle).to be false
  end

  it 'Castle left moves with castle' do
    game = Chess.new({
                       'a1' => '{"moved":false,"location":[0,0],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e1' => '{"moved":false,"location":[0,4],"points":100,"alignment":"white","notation":"K","picture":"♔","type":"king","en_passant":false}', # rubocop:disable Layout/LineLength
                       'h1' => '{"moved":false,"location":[0,7],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e8' => '{"moved":false,"location":[7,4],"points":100,"alignment":"black","notation":"K","picture":"♚","type":"king","en_passant":false}' # rubocop:disable Layout/LineLength
                     })
    row_col = game.get_row_column('A1')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board)
    # pp moves
    expect(moves.length).to eq(11)
    result = moves.include?([:'40', 'castle_0-0-0'])
    expect(result).to be true
  end

  it 'King moves with castling' do
    game = Chess.new({
                       'a1' => '{"moved":false,"location":[0,0],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e1' => '{"moved":false,"location":[0,4],"points":100,"alignment":"white","notation":"K","picture":"♔","type":"king","en_passant":false}', # rubocop:disable Layout/LineLength
                       'h1' => '{"moved":false,"location":[0,7],"points":5,"alignment":"white","notation":"R","picture":"♖","type":"rook","en_passant":false}', # rubocop:disable Layout/LineLength
                       'e8' => '{"moved":false,"location":[7,4],"points":100,"alignment":"black","notation":"K","picture":"♚","type":"king","en_passant":false}' # rubocop:disable Layout/LineLength
                     })
    row_col = game.get_row_column('E1')
    moves = game.board[row_col[0]][row_col[1]].potential_moves(game.board)
    # pp moves
    expect(moves.length).to eq(5)
    result = moves.map { |cell| cell[0] }.include?(:'00')
    expect(result).to be true
  end
end
