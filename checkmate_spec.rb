describe "Checkmate" do
  let(:board) { make_board }

  it "works as expected" do
    board.make_a_move(square(4, 6), square(4, 4))
    check_rendering_of board, '
      ♜♞♝♛♚♝♞♜
      ♟♟♟♟♟♟♟♟
      --------
      --------
      ----♙---
      --------
      ♙♙♙♙-♙♙♙
      ♖♘♗♕♔♗♘♖
    '
    board.make_a_move(square(1, 1), square(1, 2))
    check_rendering_of board, '
      ♜♞♝♛♚♝♞♜
      ♟-♟♟♟♟♟♟
      -♟------
      --------
      ----♙---
      --------
      ♙♙♙♙-♙♙♙
      ♖♘♗♕♔♗♘♖
    '
    board.make_a_move(square(3, 7), square(5, 5))
    check_rendering_of board, '
      ♜♞♝♛♚♝♞♜
      ♟-♟♟♟♟♟♟
      -♟------
      --------
      ----♙---
      -----♕--
      ♙♙♙♙-♙♙♙
      ♖♘♗-♔♗♘♖
    '
    board.make_a_move(square(1, 0), square(2, 2))
    check_rendering_of board, '
      ♜-♝♛♚♝♞♜
      ♟-♟♟♟♟♟♟
      -♟♞-----
      --------
      ----♙---
      -----♕--
      ♙♙♙♙-♙♙♙
      ♖♘♗-♔♗♘♖
    '
    board.make_a_move(square(5, 7), square(2, 4))
    check_rendering_of board, '
      ♜-♝♛♚♝♞♜
      ♟-♟♟♟♟♟♟
      -♟♞-----
      --------
      --♗-♙---
      -----♕--
      ♙♙♙♙-♙♙♙
      ♖♘♗-♔-♘♖
    '
    board.make_a_move(square(2, 0), square(1, 1))
    check_rendering_of board, '
      ♜--♛♚♝♞♜
      ♟♝♟♟♟♟♟♟
      -♟♞-----
      --------
      --♗-♙---
      -----♕--
      ♙♙♙♙-♙♙♙
      ♖♘♗-♔-♘♖
    '
    board.make_a_move(square(5, 5), square(5, 1))
    check_rendering_of board, '
      ♜--♛♚♝♞♜
      ♟♝♟♟♟♕♟♟
      -♟♞-----
      --------
      --♗-♙---
      --------
      ♙♙♙♙-♙♙♙
      ♖♘♗-♔-♘♖
    '
    board.any_valid_moves_for_player_on_turn?
    board.white_win?.should be_true
  end
end

def make_board
  ChessBoard.new
end

def square(*args)
  Square.new(*args)
end

def check_rendering_of(board, expected)
  output = board.print
  output.should eq rendering(expected)
end

def rendering(text)
  text.strip.gsub(/^\s+/, '')
end
