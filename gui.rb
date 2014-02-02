require 'green_shoes'
require './chess.rb'

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480
BOX_SIZE = 50
BOARD_WIDTH = 8
BOARD_HEIGHT = 8
X_MARGIN = (WINDOW_WIDTH - BOARD_WIDTH * BOX_SIZE).div 2
Y_MARGIN = (WINDOW_HEIGHT - BOARD_HEIGHT * BOX_SIZE).div 2
LIGHT_BOX_COLOR = [255, 170, 85]
DARK_BOX_COLOR = [102, 51, 0]
BACKGROUND = [50, 0, 0]
TEXT_COLOR = [255, 255, 255]
RED = [255, 0, 0]
GREEN = [0, 155, 0]
TEXT_BACKGROUND = GREEN
WHITE = 'white'
BLACK = 'black'
EMPTY = nil
TITLE = "ruby-chess"

def top_left_coordinates_of(square)
  left = square[0] * BOX_SIZE + Y_MARGIN
  top = square[1] * BOX_SIZE + X_MARGIN
  [top, left]
end

def left_top_coordinates_of(square)
  left = square[0] * BOX_SIZE + X_MARGIN
  top = square[1] * BOX_SIZE + Y_MARGIN
  [left, top]
end

def draw_board
  BOARD_HEIGHT.times do |row|
    BOARD_WIDTH.times do |column|
      top, left = top_left_coordinates_of([column, row])
      (row + column).remainder(2).zero? ? fill(rgb(*LIGHT_BOX_COLOR)) : fill(rgb(*DARK_BOX_COLOR))
      rect top, left, BOX_SIZE, BOX_SIZE
    end
  end
end

def draw_pieces(board)
  BOARD_HEIGHT.times do |row|
    BOARD_WIDTH.times do |column|
      square = Square.new(row, column)
      case board.piece_on(square)
        when EMPTY
          next
        else
          picture = image board.piece_on(square).image_path
          picture.move *left_top_coordinates_of(square.to_a)
      end
    end
  end
end

def get_square_at(pixel)
  x = (pixel[0] - X_MARGIN).div BOX_SIZE
  y = (pixel[1] - Y_MARGIN).div BOX_SIZE
  Square.new(x, y)
end

board = ChessBoard.new
first_selection = EMPTY

Shoes.app(width: WINDOW_WIDTH, height: WINDOW_HEIGHT, title: TITLE) do
  background rgb(*BACKGROUND)
  draw_board
  draw_pieces(board)

  click do |button, left, top|
    square = get_square_at([left, top])
    unless square.out_of_the_board
      if first_selection
        board.make_a_move(first_selection, square)
        first_selection = EMPTY
        draw_board
        draw_pieces(board)
      else
        first_selection = square
      end
    end
  end
end