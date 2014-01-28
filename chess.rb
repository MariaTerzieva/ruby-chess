class Piece
  WHITE = "white".freeze
  BLACK = "black".freeze

  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end

  def obstructions?(dx, dy, steps, position)
    (1...steps).each do |step|
      x = position[0] + step * dx
      y = position[1] + step * dy
      return true unless @board.empty([x, y])
    end
    false
  end
end

class Queen < Piece
end

class Bishop < Piece
  def valid_move(from, to)
    return false if (from[0] - to[0]).abs != (from[1] - to[1])
    dx = to[0] < from[0] ? 1 : -1
    dy = to[1] < from[1] ? 1 : -1
    steps = (from[0] - to[0]).abs
    return false if obstructions?(dx, dy, steps, from)
    @board.king_remains_safe_after_move(from, to)
  end
end

class Knight < Piece
end

class Pawn < Piece
  attr_reader :moved

  def initialize(color)
    super
    @moved = false
  end

  def valid_direction?(from, to)
    if @board.color_of_piece_on(from) == WHITE
      to[1] < from[1]
    else
      to[1] > from[1]
    end
  end
end

class King < Piece
  attr_reader :moved

  def initialize(color)
    super
    @moved = false
  end

  def castle?(king_position, rook_position)
    return false if moved or not piece_on(rook_position).is_a? Rook
    return false if piece_on(rook_position).moved
    kx, ky = *king_position
    args = rook_position[0] > king_position[0] ? [1, 0, 3] : [-1, 0, 4]
    return false if obstructions?(*args, king_position)
    3.times do
      return false unless king_safe([kx, ky])
      kx += args[0]
    end
    true
  end 

  def valid_move(from, to)
    return false if (from[1] - to[1]).abs > 1
    if (from[0] - to[0]).abs > 1
      return castle?(from, [7, from[1]]) if to[0] == from[0] + 2 and from[1] == to[1]
      return castle?(from, [0, from[1]]) if to[0] == from[0] - 2 and from[1] == to[1]
      false
    end
    @board.king_remains_safe_after_move(from, to)
  end

  def safe_from(position)
    not (attacked_by_a_pawn(*position) or attacked_by_a_knight(*position) or attacked_by_other(position))
  end

  def attacked_by_a_pawn(x, y)
    if color == WHITE
      positions = [[x + 1, y - 1], [x - 1, y - 1]]
    else
      positions = [[x + 1, y + 1], [x + 1, y + 1]]
    end
    positions.any? do |position|
      @board.piece_on(position).is_a? Pawn and @board.piece_on(position).color != color
    end
  end

  def attacked_by_a_knight(x, y)
    positions = [[x + 2, y + 1], [x + 2, y - 1], [x - 2, y + 1],
                [x - 2, y - 1], [x + 1, y + 2], [x + 1, y - 2],
                [x - 1, y + 2], [x - 1, y - 2]]
    positions.any? do |position|
      @board.piece_on(position).is_a? Knight and @board.piece_on(position).color != color
    end
  end
  
  def attacked_by_other(position)
    directions = [[1, 0], [-1, 0], [0, 1], [0, -1],
                  [1, 1], [-1, 1], [1, -1], [-1, -1]]
    directions.each do |dx, dy|
      x, y, steps = *position, 0
      while true
        x, y, steps = x + dx, y + dy, steps + 1
        break if [x, y].any? { |coordinate| coordinate < 0 or coordinate > 7 }
        next if @board.empty([x, y])
        break if @board.color_of_piece_on([x, y]) == color
        case @board.piece_on([x, y])
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
end

class Rook < Piece
  attr_reader :moved

  def initialize(color)
    super
    @moved = false
  end

  def valid_move(from, to)
    return false if from[0] != to[0] and from[1] != to[1]
    dx = to[0] <=> from[0]
    dy = to[1] <=> to[1]
    steps = [(from[0] - to[0]).abs, (from[1] - to[1]).abs].max
    return false if obstructions?(dx, dy, steps, from)
    @board.king_remains_safe_after_move(from, to)
  end
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
      @board[column, 1] = Pawn.new(BLACK, self)
      @board[column, 6] = Pawn.new(WHITE, self)
    end
    @turn = WHITE
    @game_status = GAME_IN_PROGRESS
  end

  def move(from, to)
    @board[to] = @board[from]
    @board.delete from
  end

  def king_remains_safe_after_move(from, to)
    from_before_move = piece_on(from)
    to_before_move = piece_on(to)
    move(from, to)
    king_position, king = king_of(@turn).to_a.flatten
    result = king.safe_from(king_position)
    @board[from] = from_before_move
    @board[to] = to_before_move
    result
  end

  def out_of_the_board?(from, to)
    [from, to].flatten.any? { |coordinate| coordinate < 0 or coordinate > 7 }
  end

  def color_of_piece_on(position)
    @board[position].color
  end

  def king_of(color)
    @board.select { |_, piece| piece.is_a? King and piece.color == color }
  end

  def empty?(position)
    @board[position].nil?
  end

  def piece_on(position)
    @board[position]
  end

  def pieces_of_the_same_color?(from, to)
    return false if empty?(to)
    color_of_piece_on(from) == color_of_piece_on(to)
  end
end
