require_relative 'chess/square'
require_relative 'chess/queen'
require_relative 'chess/bishop'
require_relative 'chess/knight'
require_relative 'chess/pawn'
require_relative 'chess/king'
require_relative 'chess/rook'

class ChessBoard
  attr_reader :game_status, :turn

  WHITE = "white".freeze
  BLACK = "black".freeze
  GAME_IN_PROGRESS = "Game in progress.".freeze
  BLACK_WIN = "Black win!".freeze
  WHITE_WIN = "White win!".freeze
  STALEMATE = "Stalemate!".freeze

  def initialize
    @board = {
      [0, 0] => Rook.new(BLACK, self), [1, 0] => Knight.new(BLACK, self),
      [2, 0] => Bishop.new(BLACK, self), [3, 0] => Queen.new(BLACK, self),
      [4, 0] => King.new(BLACK, self), [5, 0] => Bishop.new(BLACK, self),
      [6, 0] => Knight.new(BLACK, self), [7, 0] => Rook.new(BLACK, self),
      [0, 7] => Rook.new(WHITE, self), [1, 7] => Knight.new(WHITE, self),
      [2, 7] => Bishop.new(WHITE, self), [3, 7] => Queen.new(WHITE, self),
      [4, 7] => King.new(WHITE, self), [5, 7] => Bishop.new(WHITE, self),
      [6, 7] => Knight.new(WHITE, self), [7, 7] => Rook.new(WHITE, self),
    }
    0.upto(7).each do |column|
      2.upto(5).each do |row|
        @board[[column, 1]] = Pawn.new BLACK, self
        @board[[column, 6]] = Pawn.new WHITE, self
        @board[[column, row]] = nil
      end
    end
    @turn = WHITE
    @game_status = GAME_IN_PROGRESS
  end

  def move(from, to)
    @board[to.to_a] = @board[from.to_a]
    @board[from.to_a] = nil
    true
  end

  def king_remains_safe_after_move?(from, to)
    board = @board.dup
    move from, to
    x, y, king = king_of turn
    king_position = Square.new x, y
    result = king.safe_from? king_position
    @board = board
    result
  end

  def out_of_the_board?(from, to)
    from.out_of_the_board? or to.out_of_the_board?
  end

  def color_of_piece_on(position)
    @board[position.to_a].color
  end

  def king_of(color)
    @board.select { |_, piece| piece.is_a? King and piece.color == color }.to_a.flatten
  end

  def empty?(position)
    @board[position.to_a].nil?
  end

  def piece_on(position)
    @board[position.to_a]
  end

  def pieces_of_the_same_color?(from, to)
    not empty?(to) and color_of_piece_on(from) == color_of_piece_on(to)
  end

  def any_valid_moves_for_player_on_turn?
    @board.any? do |from, piece|
      next if empty? Square.new *from
      piece.color == turn and piece.any_moves? Square.new *from
    end
  end

  def king_of_current_player_is_in_check?
    x, y, king = king_of turn
    true unless king.safe_from? Square.new x, y
  end

  def switch_players
    @turn = turn == WHITE ? BLACK : WHITE
  end

  def player_owns_piece_on?(position)
    turn == color_of_piece_on(position)
  end

  def allowed_to_move_piece_on?(from, to)
    piece_on(from).move from, to
  end

  def game_over?
    unless any_valid_moves_for_player_on_turn?
      if king_of_current_player_is_in_check?
        @game_status = turn == WHITE ? BLACK_WIN : WHITE_WIN
      else
        @game_status = STALEMATE
      end
    end
  end

  def make_a_move(from, to)
    return if empty? from
    return if out_of_the_board? from, to
    return if pieces_of_the_same_color? from, to
    return if from == to
    return unless player_owns_piece_on? from
    return unless allowed_to_move_piece_on? from, to
    switch_players
    game_over?
  end

  def white_win?
    @game_status == WHITE_WIN
  end

  def black_win?
    @game_status == BLACK_WIN
  end

  def stalemate?
    @game_status == STALEMATE
  end

  def print
    result = ""
    0.upto(7).each do |row|
      0.upto(7).each do |column|
        square = Square.new column, row
        result << (empty?(square) ? '-' : piece_on(square).symbol)
      end
      result << "\n"
    end
    result.chomp
  end
end