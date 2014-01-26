class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Queen < Piece
end

class Bishop < Piece
end

class Knight < Piece
end

class Pawn < Piece
  attr_reader :moved

  def initialize(color)
    super
    @moved = false
  end
end

class King < Pawn
end

class Rook < Pawn
end

class ChessBoard
  WHITE = "white".freeze
  BLACK = "black".freeze
  GAME_IN_PROGRESS = "Game in progress.".freeze
  BLACK_WIN = "Black win!".freeze
  WHITE_WIN = "White win!".freeze
  STALEMATE = "Stalemate!".freeze

  def initialize
    @board = {
      [0, 0] => Rook.new(BLACK), [1, 0] => Knight.new(BLACK),
      [2, 0] => Bishop.new(BLACK), [3, 0] => Queen.new(BLACK),
      [4, 0] => King.new(BLACK), [5, 0] => Bishop.new(BLACK),
      [6, 0] => Knight.new(BLACK), [7, 0] => Rook.new(BLACK),
      [0, 7] => Rook.new(WHITE), [1, 7] => Knight.new(WHITE),
      [2, 7] => Bishop.new(WHITE), [3, 7] => Queen.new(WHITE),
      [4, 7] => King.new(WHITE), [5, 7] => Bishop.new(WHITE),
      [6, 7] => Knight.new(WHITE), [7, 7] => Rook.new(WHITE),
    }
    0.upto(7).each do |column|
      @board[column, 1] = Pawn.new(BLACK)
      @board[column, 6] = Pawn.new(WHITE)
    end
    @turn = WHITE
    @game_status = GAME_IN_PROGRESS
  end

  def out_of_the_board?(from, to)
    [from, to].flatten.any? { |coordinate| coordinate < 0 or coordinate > 7 }
  end

  def color_of_player_on(position)
    @board[position].color
  end

  def empty?(position)
    @board[position].nil?
  end
end
