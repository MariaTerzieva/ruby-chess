require 'green_shoes'
require 'yaml/store'
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

def save_game(board)
  Shoes.app(width: 320, height: 100, title: TITLE) do
    background white
    border green, strokewidth: 6
    stack(margin: 12) do
      para "Enter name of the game"
      flow do
        input = edit_line
        ok = button "OK"
        ok.click do
          store = YAML::Store.new "./games.store"
          store.transaction do
            store[input.text] = board
          end
          exit
        end
      end
    end
  end
end

def load_game
  input = edit_line
  ok = button "OK"
  ok.click do
    store = YAML::Store.new "./games.store"
    store.transaction do
      board = store[input.text]
    end
  end
  ok.remove
  input.remove
  board
end

def mark(square, board)
  left, top = left_top_coordinates_of(square.to_a)
  fill red
  rect left, top, BOX_SIZE, BOX_SIZE
  if board.piece_on(square)
    piece = image board.piece_on(square).image_path
    piece.move left, top
  end
end

def winner_alert(status)
  Shoes.app(width: WINDOW_WIDTH, height: WINDOW_HEIGHT, title: TITLE) do
    background rgb(*BACKGROUND)
    title(status,
          top: WINDOW_HEIGHT.div(2),
          align: "center",
          font: "Trebuchet MS",
          stroke: white)
    ok_button = button "OK"
    ok_button.move WINDOW_WIDTH.div(2), (WINDOW_HEIGHT.div(2) + 50)
    ok_button.click { exit }
  end
end

def check_for_winner(board)
  if board.white_win? or board.black_win? or board.stalemate?
    winner_alert board.game_status
  end
end

def game(board)
  first_selection = EMPTY
  background rgb(*BACKGROUND)
  draw_board
  draw_pieces(board)
  save = button "Save game"
  save.move 550, 12

  save.click { save_game(board) }

  click do |button, left, top|
    square = get_square_at([left, top])
    unless square.out_of_the_board
      if first_selection
        board.make_a_move(first_selection, square)       
        check_for_winner(board)
        first_selection = EMPTY
        draw_board
        draw_pieces(board)
      else
        first_selection = square
        mark square, board
      end
    end
  end
end

Shoes.app(width: WINDOW_WIDTH, height: WINDOW_HEIGHT, title: TITLE) do
  background rgb(*BACKGROUND)
  stack(margin: 10) do
    new_game = button "New  game"
    load = button "Load game"

    new_game.click { game(ChessBoard.new) }
    load.click do
      input = edit_line width: 100
      ok = button "OK"
      ok.click do
        store = YAML::Store.new "./games.store"
        ok.hide
        input.remove
        store.transaction do
          game(store[input.text])
        end
      end
    end
  end
end