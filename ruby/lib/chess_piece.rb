# frozen_string_literal: true

require 'json'

# Parent class for chess
class ChessPiece # rubocop:disable Metrics/ClassLength
  attr_reader :picture, :alignment, :type, :points
  attr_accessor :en_passant, :moved, :location

  def initialize(location, points, alignment, notation, picture, type) # rubocop:disable Metrics/ParameterLists
    @moved = false
    @location = location
    @points = points
    @alignment = alignment
    @notation = notation
    @picture = picture
    @type = type
    @en_passant = false
  end

  # Returns array of strings of Column-Row and special move
  def potential_moves(board) # rubocop:disable Lint/UnusedMethodArgument
    []
  end

  def to_json(*_args)
    JSON.dump({
                moved: @moved,
                location: @location,
                points: @points,
                alignment: @alignment,
                notation: @notation,
                picture: @picture,
                type: @type,
                en_passant: @en_passant
              })
  end

  def self.from_json(string)
    data = JSON.parse string
    new(data['location'], data['alignment'], data['en_passant'])
  end

  def is_valid_location?(cell, board) # rubocop:disable Naming/PredicateName
    if cell[0] >= 0 && cell[0] < 8 && cell[1] >= 0 && cell[1] < 8
      cell_piece = board[cell[0]][cell[1]]

      return [cell_piece.nil? || cell_piece.alignment != alignment, !cell_piece.nil?]
    end
    [false, false]
  end

  def check_moves_in_loop(row_increment, column_increment, board) # rubocop:disable Metrics/MethodLength
    ret = []
    row = @location[0] + row_increment
    column = @location[1] + column_increment
    should_stop = false
    until should_stop
      valid = is_valid_location?([row, column], board)
      if valid[0]
        ret.push([:"#{column}#{row}", nil])
        should_stop = true if valid[1]
      else
        should_stop = true
      end
      row += row_increment
      column += column_increment
    end
    ret
  end

  def in_check?(board, side_to_check = @alignment) # rubocop:disable Metrics/AbcSize,Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
    # get the current sides king and its location
    kings = board.flatten.select { |cell| !cell.nil? && cell.alignment == side_to_check && cell.type == 'king' }
    return false if kings.length <= 0

    king = kings[0]
    king_location = :"#{king.location[1]}#{king.location[0]}"

    # get all the opposite sides pieces
    opposite_pieces = board.flatten.select { |cell| !cell.nil? && cell.alignment != side_to_check }

    # get their potential moves and if the king is in those moves
    opposite_pieces.each do |piece|
      moves = piece.potential_moves(board)
      return true if moves.flatten.include?(king_location)
    end

    false
  end

  def in_checkmate?(board, side_to_check = @alignment)
    # get the current side
    current_side = board.flatten.select { |cell| !cell.nil? && cell.alignment == side_to_check }
    current_side.each do |piece|
      moves = piece.potential_moves(board)
      return false if moves.length.positive?
    end
    true
  end

  # Column-Row and special move. Return new board, any taken piece and if in check
  def preview_move(destination_special_move, board) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    # TODO: Pawn promotion
    new_board = board.map { |row| row.map(&:dup) }
    special_move = destination_special_move[1]
    destination = destination_special_move[0].to_s.chars.reverse.map(&:to_i)
    # pp destination
    # puts 'location piece'
    # pp new_board[@location[0]][@location[1]]
    # pp @location

    if special_move.nil? || special_move == 'doubleStep' || special_move.start_with?('enPassant')
      # taken_piece = new_board[destination[0]][destination[1]]
      new_board[destination[0]][destination[1]] = new_board[@location[0]][@location[1]]
      new_board[@location[0]][@location[1]] = nil
    end

    if !special_move.nil? && special_move.start_with?('enPassant')
      take_piece_col_row = special_move.split('_')[1]
      take_piece_location = take_piece_col_row.chars.reverse.map(&:to_i)
      # taken_piece = new_board[take_piece_location[0]][take_piece_location[1]]
      new_board[take_piece_location[0]][take_piece_location[1]] = nil
    end

    ## Castling
    if !special_move.nil? && special_move.start_with?('castle')
      castle_type = special_move.split('_')[1]
      rook_location = []
      rook_new_location = []
      king_new_location = []
      king_location = new_board.flatten.compact.select do |cell|
                        cell.alignment == @alignment && cell.type == 'king'
                      end[0].location
      if castle_type == '0-0-0'
        if @alignment == 'white'
          rook_new_location = [0, 3]
          king_new_location = [0, 2]
          rook_location = [0, 0]
        else
          rook_new_location = [7, 3]
          king_new_location = [7, 2]
          rook_location = [7, 0]
        end
      else
        if @alignment == 'white' # rubocop:disable Style/IfInsideElse
          rook_new_location = [0, 5]
          king_new_location = [0, 6]
          rook_location = [0, 7]
        else
          rook_new_location = [7, 5]
          king_new_location = [7, 6]
          rook_location = [7, 7]
        end
      end
      new_board[king_new_location[0]][king_new_location[1]] = new_board[king_location[0]][king_location[1]]
      new_board[king_location[0]][king_location[1]] = nil

      new_board[rook_new_location[0]][rook_new_location[1]] = new_board[rook_location[0]][rook_location[1]]
      new_board[rook_location[0]][rook_location[1]] = nil

      # Update pieces
      new_board[king_new_location[0]][king_new_location[1]].moved = true
      new_board[king_new_location[0]][king_new_location[1]].location = king_new_location
      new_board[rook_new_location[0]][rook_new_location[1]].moved = true
      new_board[rook_new_location[0]][rook_new_location[1]].location = rook_new_location
    else
      # Update piece
      new_board[destination[0]][destination[1]].moved = true
      new_board[destination[0]][destination[1]].location = destination
      # If this is a pawn moving two then set en Passant to true (special move is doubleStep)
      new_board[destination[0]][destination[1]].en_passant = true if special_move == 'doubleStep'
    end

    # set other side en passant to false
    other_passant = new_board.flatten.compact.select { |cell| cell.alignment != @alignment && cell.en_passant }
    other_passant.each { |cell| cell.en_passant = false }

    # [new_board, taken_piece, in_check?(new_board, if @alignment == 'black'
    #                                                 'white'
    #                                               else
    #                                                 'black'
    #                                               end)]
    new_board
  end
end
