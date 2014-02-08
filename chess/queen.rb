require_relative 'piece'

class Queen < Piece
  attr_reader :symbol, :image_path

  def initialize(color, board)
    super
    @symbol = color == WHITE ? '♕' : '♛'
    @image_path = color == WHITE ? "./images/WQ.png" : "./images/BQ.png"
  end

  def valid_move?(from, to)
    Rook.new(color, @board).valid_move?(from, to) or Bishop.new(color, @board).valid_move?(from, to)
  end

  def any_moves?(from)
    in_directions = [[1, 0], [-1, 0], [0, 1], [0, -1],
                     [1, 1], [-1, 1], [1, -1], [-1, -1]]
    super from, in_directions
  end
end