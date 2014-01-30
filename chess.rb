class Square
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    x == other.x and y == other.y
  end

  def out_of_the_board
    [x, y].any? { |coordinate| coordinate < 0 or coordinate > 7 }
  end

  def to_a
    [x, y]
  end

  def delta_x(other)
    (x - other.x).abs
  end

  def delta_y(other)
    (y - other.y).abs
  end
end

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
      x = position.x + step * dx
      y = position.y + step * dy
      return true unless @board.empty?(Square.new(x, y))
    end
    false
  end

  def move(from, to)
    @board.move(from, to) if valid_move?(from, to)
  end

  def any_moves?(from, in_directions, max_steps=8)
    in_directions.each do |dx, dy|
      to, steps = Square.new(from.x, from.y), 0
      while true
        to, steps = Square.new(to.x + dx, to.y + dy), steps.succ
        break if to.out_of_the_board
        if @board.empty?(to) or @board.color_of_piece_on(to) != color
          return true if @board.king_remains_safe_after_move?(from, to)
        end
        break if @board.color_of_piece_on(to) == color or steps == max_steps
      end
    end
    false
  end
end

class Queen < Piece
  attr_reader :symbol

  def initialize(color, board)
    super
    @symbol = color == WHITE ? '♕' : '♛'
  end

  def valid_move?(from, to)
    Rook.new(color, @board).valid_move?(from, to) or Bishop.new(color, @board).valid_move?(from, to)
  end

  def any_moves?(from)
    in_directions = [[1, 0], [-1, 0], [0, 1], [0, -1],
                     [1, 1], [-1, 1], [1, -1], [-1, -1]]
    super(from, in_directions)
  end
end

class Bishop < Piece
  attr_reader :symbol

  def initialize(color, board)
    super
    @symbol = color == WHITE ? '♗' : '♝'
  end

  def valid_move?(from, to)
    return false if from.delta_x(to) != from.delta_y(to)
    dx = from.x <=> to.x
    dy = from.y <=> to.y
    steps = from.delta_x(to)
    return false if obstructions?(dx, dy, steps, from)
    @board.king_remains_safe_after_move?(from, to)
  end

  def any_moves?(from)
    in_directions = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
    super(from, in_directions)
  end
end

class Knight < Piece
  attr_reader :symbol

  def initialize(color, board)
    super
    @symbol = color == WHITE ? '♘' : '♞'
  end

  def valid_move?(from, to)
    horizontal = from.delta_x(to) == 2 and from.delta_y(to) == 1
    vertical = from.delta_x(to) == 1 and from.delta_y(to) == 2
    return false unless vertical or horizontal
    @board.king_remains_safe_after_move?(from, to)
  end

  def any_moves?(from)
    positions = [[from.x + 1, from.y + 2], [from.x + 2, from.y + 1],
                 [from.x + 2, from.y - 1], [from.x + 1, from.y - 2],
                 [from.x - 1, from.y + 2], [from.x - 2, from.y + 1],
                 [from.x - 1, from.y - 2], [from.x - 2, from.y - 1]]
    positions.each do |position|
      next unless position.all? { |coordinate| coordinate.between?(0, 7) }
      return true if valid_move?(from, Square.new(*position))
    end
  end
end

class Pawn < Piece
  attr_reader :moved, :symbol

  def initialize(color, board)
    super
    @moved = false
    @symbol = color == WHITE ? '♙' : '♟'
  end

  def valid_move?(from, to)
    return false unless valid_direction?(from, to)
    if from.delta_y(to) == 1
      return false if from.x == to.x and not @board.empty?(to)
      return false if from.delta_x(to) == 1 and @board.empty?(to)
    elsif from.delta_y(to) == 2
      return false if moved or from.x != to.x or obstructions?(0, to.y <=> from.y , 3, from)
    else
      return false
    end
    @board.king_remains_safe_after_move?(from, to)
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
    positions.each do |position|
      next unless position.all? { |coordinate| coordinate.between?(0, 7) }
      position = Square.new(*position)
      return true if empty_or_opponent_on(position) and valid_move?(from, position)
    end
  end

  def move(from, to)
    if super
      @board.pawn_promotion_position = to if to.y == 0 or to.y == 7
      @moved = true
    end
  end
end

class King < Piece
  attr_reader :moved, :symbol

  def initialize(color, board)
    super
    @moved = false
    @symbol = color == WHITE ? '♔' : '♚'
  end

  def castle?(king_position, rook_position)
    return false if moved or not piece_on(rook_position).is_a? Rook
    return false if piece_on(rook_position).moved
    square_between_king_and_rook = Square.new(king_position.x, king_position.y)
    dx, dy, steps = rook_position.x > king_position.x ? [1, 0, 3] : [-1, 0, 4]
    return false if obstructions?(dx, dy, steps, king_position)
    3.times do
      return false unless king_safe?(square_between_king_and_rook)
      square_between_king_and_rook.x += dx
    end
    true
  end 

  def valid_move?(from, to)
    return false if from.delta_y(to) > 1
    if from.delta_x(to) > 1
      if to.x == from.x + 2 and from.y == to.y
        rook_position = Square.new(7, from.y)
        return false unless castle?(from, rook_position)
      elsif to.x == from.x - 2 and from.y == to.y
        rook_position = Square.new(0, from.y)
        return false unless castle?(from, rook_position) 
      else
        return false
      end
    end
    @board.king_remains_safe_after_move?(from, to)
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
      @board.piece_on(position).is_a? Pawn and @board.piece_on(position).color != color
    end
  end

  def attacked_by_a_knight?(from)
    positions = [[from.x + 2, from.y + 1], [from.x + 2, from.y - 1],
                 [from.x - 2, from.y + 1], [from.x - 2, from.y - 1],
                 [from.x + 1, from.y + 2], [from.x + 1, from.y - 2],
                 [from.x - 1, from.y + 2], [from.x - 1, from.y - 2]]
    positions.any? do |position|
      @board.piece_on(position).is_a? Knight and @board.piece_on(position).color != color
    end
  end
  
  def attacked_by_other?(position)
    directions = [[1, 0], [-1, 0], [0, 1], [0, -1],
                  [1, 1], [-1, 1], [1, -1], [-1, -1]]
    directions.each do |dx, dy|
      to, steps = Square.new(position.x, position.y), 0
      while true
        to, steps = Square.new(to.x + dx, to.y + dy), steps.succ
        break if to.out_of_the_board
        next if @board.empty?(to)
        break if @board.color_of_piece_on(to) == color
        case @board.piece_on(to)
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
    return true if super(from, in_directions)
    right_rook_position = Square.new(from.x + 3, from.y)
    left_rook_position = Square.new(from.x - 4, from.y)
    castle?(from, right_rook_position) or castle?(from, left_rook_position)
  end

  def move(from, to)
    if valid_move?(from, to)
      if to.x == from.x + 2
        @board.move(Square.new(7, to.y), Square.new(5, to.y))
      elsif to.x == from.x - 2
        @board.move(Square.new(0, to.y), Square.new(3, to.y))
      end
      @board.move(from, to)
      @moved = true
    end
  end
end

class Rook < Piece
  attr_reader :moved, :symbol

  def initialize(color, board)
    super
    @moved = false
    @symbol = color == WHITE ? '♖' : '♜'
  end

  def valid_move?(from, to)
    return false if from.x != to.x and from.y != to.y
    dx = to.x <=> from.x
    dy = to.y <=> from.y
    steps = [from.delta_x(to), from.delta_y(to)].max
    return false if obstructions?(dx, dy, steps, from)
    @board.king_remains_safe_after_move?(from, to)
  end

  def any_moves?(from)
    in_directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    super(from, in_directions)
  end

  def move(from, to)
    @moved = true if super
  end
end

class ChessBoard
  attr_reader :game_status, :turn
  attr_writer :pawn_promotion_position

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
        @board[[column, 1]] = Pawn.new(BLACK, self)
        @board[[column, 6]] = Pawn.new(WHITE, self)
        @board[[column, row]] = nil
      end
    end
    @turn = WHITE
    @game_status = GAME_IN_PROGRESS
    @pawn_promotion_position = nil
  end

  def move(from, to)
    @board[to.to_a] = @board[from.to_a]
    @board[from.to_a] = nil
    true
  end

  def king_remains_safe_after_move?(from, to)
    board = @board.dup
    move(from, to)
    x, y, king = king_of(turn)
    king_position = Square.new(x, y)
    result = king.safe_from?(king_position)
    @board = board
    result
  end

  def out_of_the_board?(from, to)
    from.out_of_the_board or to.out_of_the_board
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
    @board.each do |from, piece|
      return true if piece.color == turn and piece.any_moves?(Square.new(*from))
    end
    false
  end

  def king_of_current_player_is_in_check?
    x, y, king = king_of(turn)
    true unless king.safe_from?(Square.new(x, y))
  end

  def switch_players
    @turn = turn == WHITE ? BLACK : WHITE
  end

  def player_owns_piece_on?(position)
    turn == color_of_piece_on(position)
  end

  def allowed_to_move_piece_on?(from, to)
    piece_on(from).move(from, to)
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
    return if empty?(from)
    return if out_of_the_board?(from, to)
    return if pieces_of_the_same_color?(from, to)
    return if from == to
    return unless player_owns_piece_on?(from)
    return unless allowed_to_move_piece_on?(from, to)
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

  def promote_pawn_to(piece)
    @board[pawn_promotion_position.to_a] = piece
    @pawn_promotion_position = nil
    game_over?
  end

  def promotion?
    @pawn_promotion_position
  end

  def print
    result = ""
    0.upto(7).each do |row|
      0.upto(7).each do |column|
        square = Square.new(column, row)
        result << (empty?(square) ? '-' : piece_on(square).symbol)
      end
      result << "\n"
    end
    result.chomp
  end
end
