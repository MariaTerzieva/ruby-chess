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
  EMPTY = nil.freeze
  WHITE = "white".freeze
  BLACK = "black".freeze
  GAME_IN_PROGRESS = "Game in progress.".freeze
  BLACK_WIN = "Black win!".freeze
  WHITE_WIN = "White win!".freeze
  STALEMATE = "Stalemate!".freeze

  def initialize
    @board = {}
    @turn = WHITE
    @game_status = GAME_IN_PROGRESS
  end
end

