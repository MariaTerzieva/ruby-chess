describe "Square" do
  let(:square1) { make_square 0, 0 }
  let(:square2) { make_square 7, 7 }
  let(:square3) { make_square 0, 0 }

  it "can be converted to an array" do
    square1.to_a.should eq [0, 0]
  end

  it "is false if coordinates differ" do
    (square1 == square2).should be_false
  end

  it "is true if coordinates are the same" do
    (square1 == square3).should be_true
  end

  it "is true if square is out of the chess board" do
    square = make_square(-1, 8)
    square.out_of_the_board.should be_true
  end

  it "calculates the distance between the x coordinates of two squares" do
    square1.delta_x(square2).should eq 7
  end

  it "calculates the distance between the y coordinates of two squares" do
    square1.delta_y(square2).should eq 7
  end
end

describe "ChessBoard" do
  let(:board) { make_board }

  it "prints the board correctly" do
    check_rendering_of board, '
      ♜♞♝♛♚♝♞♜
      ♟♟♟♟♟♟♟♟
      --------
      --------
      --------
      --------
      ♙♙♙♙♙♙♙♙
      ♖♘♗♕♔♗♘♖
    '
  end

  it "is properly initialized" do
    board.game_status.should eq "Game in progress."
    board.promotion?.should be_false
    board.turn.should eq "white"
  end

  it "move works" do
    from = make_square(0, 1)
    to = make_square(0, 3)
    board.move(from, to)
    board.piece_on(to).symbol.should eq '♟'
    board.empty?(from).should be_true
  end

  it "checks if king remains safe after move" do
    from = make_square(0, 1)
    to = make_square(0, 3)
    board.move(from, to)
    board.king_remains_safe_after_move?(from, to).should be_true
  end

  it "checks if coordinates are out of the board" do
    from = make_square(-1, 1)
    to = make_square(4, 8)
    board.out_of_the_board?(from, to).should be_true
  end

  it "returns the color of the piece on a given position" do
    black_pawn_position = make_square(0, 1)
    white_queen_position = make_square(3, 7)
    board.color_of_piece_on(black_pawn_position).should eq "black"
    board.color_of_piece_on(white_queen_position).should eq "white"
  end

  it "gets the white king" do
    x, y, king = board.king_of("white")
    [x, y].should eq [4, 7]
    king.symbol.should eq '♔'
  end

  it "gets the black king" do
    x, y, king = board.king_of("black")
    [x, y].should eq [4, 0]
    king.symbol.should eq '♚'
  end

  it "determines if a positon is empty" do
    square = make_square(5, 5)
    board.empty?(square).should be_true
    black_queen_postion = make_square(3, 0)
    board.empty?(black_queen_postion).should be_false
  end

  it "returns piece on a given position" do
    square = make_square(7, 7)
    board.piece_on(square).symbol.should eq "♖"
    empty_square = make_square(5, 5)
    board.piece_on(empty_square).should be_nil
  end

  it "determines if two squares hold pieces of the same color" do
    square1 = make_square(0, 0)
    square2 = make_square(7, 7)
    square3 = make_square(5, 5)
    board.pieces_of_the_same_color?(square1, square2).should be_false
    board.pieces_of_the_same_color?(square1, square3).should be_false
  end

  it "determines if player on turn has any moves left" do
    board.any_valid_moves_for_player_on_turn?.should be_true
  end

  it "determines if the king of the current player is in check" do
    board.king_of_current_player_is_in_check?.should be_false
  end
end

def make_square(*args)
  Square.new(*args)
end

def make_board
  ChessBoard.new
end

def check_rendering_of(board, expected)
  output = board.print
  output.should eq rendering(expected)
end

def rendering(text)
  text.strip.gsub(/^\s+/, '')
end