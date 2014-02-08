class Piece
  WHITE = "white".freeze
  BLACK = "black".freeze

  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end

  def obstructions?(dx, dy, steps, position)
    (1...steps).any? do |step|
      x = position.x + step * dx
      y = position.y + step * dy
      not @board.empty? Square.new x, y
    end
  end

  def move(from, to)
    @board.move from, to if valid_move? from, to
  end

  def any_moves?(from, in_directions, max_steps=8)
    in_directions.each do |dx, dy|
      to = Square.new from.x + dx, from.y + dy
      steps = 0
      while steps != max_steps and to.inside_the_board?
        if @board.empty?(to) or @board.color_of_piece_on(to) != color
          return true if @board.king_remains_safe_after_move? from, to
        elsif @board.color_of_piece_on(to) == color
          break
        end
        steps += 1
        to = Square.new to.x + dx, to.y + dy
      end
    end
    false
  end
end
