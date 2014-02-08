require_relative 'piece'

class Knight < Piece
  attr_reader :symbol, :image_path

  def initialize(color, board)
    super
    @symbol = color == WHITE ? '♘' : '♞'
    @image_path = color == WHITE ? "./images/WN.png" : "./images/BN.png"
  end

  def valid_move?(from, to)
    horizontal = from.delta_x(to) == 2 and from.delta_y(to) == 1
    vertical = from.delta_x(to) == 1 and from.delta_y(to) == 2
    return false unless vertical or horizontal
    @board.king_remains_safe_after_move? from, to
  end

  def empty_or_opponent_on?(position)
    @board.empty?(position) or @board.color_of_piece_on(position) != color
  end

  def any_moves?(from)
    positions = [[from.x + 1, from.y + 2], [from.x + 2, from.y + 1],
                 [from.x + 2, from.y - 1], [from.x + 1, from.y - 2],
                 [from.x - 1, from.y + 2], [from.x - 2, from.y + 1],
                 [from.x - 1, from.y - 2], [from.x - 2, from.y - 1]]
    positions.any? do |position|
      position = Square.new(*position)
      next unless position.inside_the_board?
      empty_or_opponent_on?(position) and valid_move?(from, position)
    end
  end
end
