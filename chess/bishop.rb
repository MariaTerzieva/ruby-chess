require_relative 'piece'

class Bishop < Piece
  attr_reader :symbol, :image_path

  def initialize(color, board)
    super
    @symbol = color == WHITE ? '♗' : '♝'
    @image_path = color == WHITE ? "./images/WB.png" : "./images/BB.png"
  end

  def valid_move?(from, to)
    return false if from.delta_x(to) != from.delta_y(to)
    dx = to.x <=> from.x
    dy = to.y <=> from.y
    steps = from.delta_x to
    return false if obstructions? dx, dy, steps, from
    @board.king_remains_safe_after_move? from, to
  end

  def any_moves?(from)
    in_directions = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
    super from, in_directions
  end
end