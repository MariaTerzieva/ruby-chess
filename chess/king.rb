require_relative 'piece'
require_relative 'rook'

class King < Piece
  attr_reader :symbol, :image_path

  def initialize(color, board)
    super
    @moved = false
    @symbol = color == WHITE ? '♔' : '♚'
    @image_path = color == WHITE ? "./images/WK.png" : "./images/BK.png"
  end

  def castle?(king_position, rook_position)
    return false if @moved or not @board.piece_on(rook_position).is_a? Rook
    return false if @board.piece_on(rook_position).moved

    dx, dy, steps = rook_position.x > king_position.x ? [1, 0, 3] : [-1, 0, 4]
    return false if obstructions? dx, dy, steps, king_position

    square = Square.new king_position.x - dx, king_position.y
    3.times.all? do
      square = Square.new square.x + dx, square.y
      safe_from? square
    end
  end

  def valid_move?(from, to)
    return false if from.delta_y(to) > 1
    if from.delta_x(to) > 1
      if to.x == from.x + 2 and from.y == to.y
        rook_position = Square.new 7, from.y
        return false unless castle? from, rook_position
      elsif to.x == from.x - 2 and from.y == to.y
        rook_position = Square.new 0, from.y
        return false unless castle? from, rook_position
      else
        return false
      end
    end
    @board.king_remains_safe_after_move? from, to
  end

  def safe_from?(position)
    not (attacked_by_a_pawn?(position) or attacked_by_a_knight?(position) or attacked_by_other?(position))
  end

  def attacked_by_a_pawn?(from)
    if color == WHITE
      positions = [[from.x + 1, from.y - 1], [from.x - 1, from.y - 1]]
    else
      positions = [[from.x + 1, from.y + 1], [from.x + 1, from.y + 1]]
    end
    positions.any? do |position|
      square = Square.new(*position)
      @board.piece_on(square).is_a? Pawn and @board.piece_on(square).color != color
    end
  end

  def attacked_by_a_knight?(from)
    positions = [[from.x + 2, from.y + 1], [from.x + 2, from.y - 1],
                 [from.x - 2, from.y + 1], [from.x - 2, from.y - 1],
                 [from.x + 1, from.y + 2], [from.x + 1, from.y - 2],
                 [from.x - 1, from.y + 2], [from.x - 1, from.y - 2]]
    positions.any? do |position|
      square = Square.new(*position)
      @board.piece_on(square).is_a? Knight and @board.piece_on(square).color != color
    end
  end

  def attacked_by_other?(position)
    directions = [[1, 0], [-1, 0], [0, 1], [0, -1],
                  [1, 1], [-1, 1], [1, -1], [-1, -1]]
    directions.each do |dx, dy|
      to = Square.new position.x, position.y
      steps = 0
      while true
        to = Square.new to.x + dx, to.y + dy
        steps += 1
        break if to.out_of_the_board?
        next if @board.empty? to
        break if @board.color_of_piece_on(to) == color
        case @board.piece_on to
          when King  then return true if steps == 1
          when Queen then return true
          when Rook then return true if dx.abs != dy.abs
          when Bishop then return true if dx.abs == dy.abs
        end
        break
      end
    end
    false
  end

  def any_moves?(from)
    in_directions = [[1, 0], [-1, 0], [0, 1], [0, -1],
                    [1, 1], [-1, 1], [1, -1], [-1, -1]]
    return true if super from, in_directions, 1
    right_rook_position = Square.new from.x + 3, from.y
    left_rook_position = Square.new from.x - 4, from.y
    castle?(from, right_rook_position) or castle?(from, left_rook_position)
  end

  def move(from, to)
    if valid_move? from, to
      if to.x == from.x + 2
        @board.move Square.new(7, to.y), Square.new(5, to.y)
      elsif to.x == from.x - 2
        @board.move Square.new(0, to.y), Square.new(3, to.y)
      end
      @board.move from, to
      @moved = true
    end
  end
end