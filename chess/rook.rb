require_relative 'piece'

class Rook < Piece
  attr_reader :moved, :symbol, :image_path

  def initialize(color, board)
    super
    @moved = false
    @symbol = color == WHITE ? '♖' : '♜'
    @image_path = color == WHITE ? "./images/WR.png" : "./images/BR.png"
  end

  def valid_move?(from, to)
    return false if from.x != to.x and from.y != to.y
    dx = to.x <=> from.x
    dy = to.y <=> from.y
    steps = [from.delta_x(to), from.delta_y(to)].max
    return false if obstructions? dx, dy, steps, from
    @board.king_remains_safe_after_move? from, to
  end

  def any_moves?(from)
    in_directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    super from, in_directions
  end

  def move(from, to)
    @moved = true if super
  end
end