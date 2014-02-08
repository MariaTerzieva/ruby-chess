require_relative 'piece'

class Pawn < Piece
  attr_reader :symbol, :image_path

  def initialize(color, board)
    super
    @moved = false
    @symbol = color == WHITE ? '♙' : '♟'
    @image_path = color == WHITE ? "./images/WP.png" : "./images/BP.png"
  end

  def valid_move?(from, to)
    return false unless valid_direction? from, to
    if from.delta_y(to) == 1 and from.delta_x(to) <= 1
      return false if from.x == to.x and not @board.empty? to
      return false if from.delta_x(to) == 1 and @board.empty? to
    elsif from.delta_y(to) == 2
      dx, dy, steps, position = 0, to.y <=> from.y, 3, from
      return false if @moved or from.x != to.x or obstructions? dx, dy, steps, position
    else
      return false
    end
    @board.king_remains_safe_after_move? from, to
  end

  def valid_direction?(from, to)
    color == WHITE ? to.y < from.y : to.y > from.y
  end

  def empty_or_opponent_on(position)
    @board.empty?(position) or @board.color_of_piece_on(position) != color
  end

  def any_moves?(from)
    positions = [[from.x + 1, from.y - 1], [from.x, from.y - 1],
                 [from.x - 1, from.y - 1], [from.x, from.y + 1],
                 [from.x + 1, from.y + 1], [from.x - 1, from.y + 1]]
    positions.any? do |position|
      position = Square.new(*position)
      next unless position.inside_the_board?
      empty_or_opponent_on(position) and valid_move?(from, position)
    end
  end

  def move(from, to)
    @moved = true if super
  end
end
