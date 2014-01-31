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
    board.white_win?.should be_true
  end

  it "white win" do
    board.make_a_move(square(4, 6), square(4, 4))
    board.make_a_move(square(1, 1), square(1, 2))
    board.make_a_move(square(3, 7), square(5, 5))
    board.make_a_move(square(1, 0), square(2, 2))
    board.make_a_move(square(5, 7), square(2, 4))
    board.make_a_move(square(3, 1), square(3, 2))
    board.make_a_move(square(5, 5), square(5, 1))
    board.make_a_move(square(4, 0), square(3, 1))
    board.make_a_move(square(2, 4), square(4, 2))
    board.white_win?.should be_true
  end

  it "white win again" do
    board.make_a_move(square(4, 6), square(4, 4))
    board.make_a_move(square(4, 1), square(4, 3))
    board.make_a_move(square(5, 7), square(2, 4))
    board.make_a_move(square(5, 0), square(2, 3))
    board.make_a_move(square(3, 7), square(7, 3))
    board.make_a_move(square(6, 0), square(5, 2))
    board.make_a_move(square(7, 3), square(5, 1))
    board.white_win?.should be_true
  end

  it "black lose" do
    board.make_a_move(square(4, 6), square(4, 4))
    board.make_a_move(square(5, 1), square(5, 2))
    board.make_a_move(square(3, 6), square(3, 4))
    board.make_a_move(square(6, 1), square(6, 3))
    board.make_a_move(square(3, 7), square(7, 3))
    board.white_win?.should be_true
  end

  it "black win" do
    board.make_a_move(square(4, 6), square(4, 4))
    board.make_a_move(square(4, 1), square(4, 3))
    board.make_a_move(square(5, 6), square(5, 4))
    board.make_a_move(square(5, 0), square(2, 3))
    board.make_a_move(square(5, 4), square(4, 3))
    board.make_a_move(square(3, 0), square(7, 4))
    board.make_a_move(square(4, 7), square(4, 6))
    board.make_a_move(square(7, 4), square(4, 4))
    board.black_win?.should be_true
  end

  it "black win again" do
    board.make_a_move(square(3, 6), square(3, 4))
    board.make_a_move(square(6, 0), square(5, 2))
    board.make_a_move(square(1, 7), square(3, 6))
    board.make_a_move(square(4, 1), square(4, 3))
    board.make_a_move(square(3, 4), square(4, 3))
    board.make_a_move(square(5, 2), square(6, 4))
    board.make_a_move(square(7, 6), square(7, 5))
    board.make_a_move(square(6, 4), square(4, 5))
    board.make_a_move(square(5, 6), square(4, 5))
    board.make_a_move(square(3, 0), square(7, 4))
    board.make_a_move(square(6, 6), square(6, 5))
    board.make_a_move(square(7, 4), square(6, 5))
    board.black_win?.should be_true
  end

  it "works as expected when the game is longer" do
    board.make_a_move(square(4, 6), square(4, 4))
    board.make_a_move(square(4, 1), square(4, 3))
    board.make_a_move(square(6, 7), square(5, 5))
    board.make_a_move(square(3, 1), square(3, 2))
    board.make_a_move(square(5, 7), square(2, 4))
    board.make_a_move(square(7, 1), square(7, 2))
    board.make_a_move(square(1, 7), square(2, 5))
    board.make_a_move(square(2, 0), square(6, 4))
    board.make_a_move(square(5, 5), square(4, 3))
    board.make_a_move(square(6, 4), square(3, 7))
    board.make_a_move(square(2, 4), square(5, 1))
    board.make_a_move(square(4, 0), square(4, 1))
    board.make_a_move(square(2, 5), square(3, 3))
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
