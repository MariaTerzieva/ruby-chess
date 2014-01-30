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

describe "Piece" do
  let(:board) { make_board }

  it "finds obstructions in a given direction" do
    square = make_square(3, 6)
    piece = make_piece("white", board)
    piece.obstructions?(0, -1, 5, square).should be_false
  end

  it "exposes it's color via getter" do
    white_piece = make_piece("white", board)
    white_piece.color.should eq "white"
    black_piece = make_piece("black", board)
    black_piece.color.should eq "black"
  end
end

describe "Queen" do
  let(:board) { make_board }

  it "exposes it's color and symbol via getters" do
    white_queen = make_queen("white", board)
    black_queen = make_queen("black", board)
    white_queen.color.should eq "white"
    white_queen.symbol.should eq '♕'
    black_queen.color.should eq "black"
    black_queen.symbol.should eq '♛'
  end

  it "finds any valid moves" do
    from = make_square(3, 7)
    queen = board.piece_on(from)
    queen.any_moves?(from).should be_false
  end

  it "determines if a move is valid" do
    from = make_square(3, 7)
    to = make_square(0, 7)
    queen = board.piece_on(from)
    queen.valid_move?(from, to).should be_false
  end
end

describe "Bishop" do
  let(:board) { make_board }

  it "exposes it's color and symbol via getters" do
    white_bishop = make_bishop("white", board)
    black_bishop = make_bishop("black", board)
    white_bishop.color.should eq "white"
    white_bishop.symbol.should eq '♗'
    black_bishop.color.should eq "black"
    black_bishop.symbol.should eq '♝'
  end

  it "finds any valid moves" do
    from = make_square(5, 0)
    bishop = board.piece_on(from)
    bishop.any_moves?(from).should be_false
  end

  it "determines if a move is valid" do
    from = make_square(5, 0)
    to = make_square(3, 2)
    bishop = board.piece_on(from)
    bishop.valid_move?(from, to).should be_false
  end
end

describe "Knight" do  
  let(:board) { make_board }

  it "exposes it's color and symbol via getters" do
    white_knight = make_knight("white", board)
    black_knight = make_knight("black", board)
    white_knight.color.should eq "white"
    white_knight.symbol.should eq '♘'
    black_knight.color.should eq "black"
    black_knight.symbol.should eq '♞'
  end

  it "finds any valid moves" do
    from = make_square(1, 0)
    knight = board.piece_on(from)
    knight.any_moves?(from).should be_true
  end

  it "determines if a move is valid" do
    from = make_square(1, 0)
    to = make_square(0, 2)
    knight = board.piece_on(from)
    knight.valid_move?(from, to).should be_true
  end
end

describe "Pawn" do
  let(:board) { make_board }

  it "exposes it's color and symbol via getters" do
    white_pawn = make_pawn("white", board)
    black_pawn = make_pawn("black", board)
    white_pawn.color.should eq "white"
    white_pawn.symbol.should eq '♙'
    black_pawn.color.should eq "black"
    black_pawn.symbol.should eq '♟'
  end

  it "finds any valid moves" do
    from = make_square(3, 6)
    pawn = board.piece_on(from)
    pawn.any_moves?(from).should be_true
  end

  it "determines if a move is valid" do
    from = make_square(3, 6)
    to = make_square(5, 5)
    pawn = board.piece_on(from)
    pawn.valid_move?(from, to).should be_false
  end

  it "moves in the right direction" do
    from = make_square(3, 6)
    to = make_square(5, 5)
    pawn = make_pawn("black", board)
    pawn.valid_direction?(from, to).should be_false
    pawn.valid_direction?(to, from).should be_true
  end

  it "determines if a position is empty or belongs to the opponent" do
    square = make_square(7, 7)
    pawn = make_pawn("black", board)
    pawn.empty_or_opponent_on(square).should be_true
  end

  it "moves as a pawn" do
    from1 = make_square(3, 6)
    to = make_square(3, 4)
    pawn1 = board.piece_on(from1)
    pawn1.move(from1, to).should be_true
    from2 = make_square(5, 6)
    pawn2 = board.piece_on(from2)
    pawn2.move(from2, to).should be_false
  end
end

describe "Rook" do
  let(:board) { make_board }

  it "exposes it's color and symbol via getters" do
    white_rook = make_rook("white", board)
    black_rook = make_rook("black", board)
    white_rook.color.should eq "white"
    white_rook.symbol.should eq '♖'
    black_rook.color.should eq "black"
    black_rook.symbol.should eq '♜'
  end

  it "finds any valid moves" do
    from = make_square(7, 7)
    rook = board.piece_on(from)
    rook.any_moves?(from).should be_false
  end

  it "determines if a move is valid" do
    from = make_square(7, 7)
    to = make_square(7, 5)
    rook = board.piece_on(from)
    rook.valid_move?(from, to).should be_false
  end
end

describe "King" do
  let(:board) { make_board }

  it "exposes its color and symbol via getters" do
    white_king = make_king("white", board)
    black_king = make_king("black", board)
    white_king.color.should eq "white"
    white_king.symbol.should eq '♔'
    black_king.color.should eq "black"
    black_king.symbol.should eq '♚'
  end

  it "finds any valid moves" do
    from = make_square(4, 7)
    king = board.piece_on(from)
    king.any_moves?(from).should be_false
  end

  it "determines if a move is valid" do
    from = make_square(4, 7)
    to = make_square(4, 5)
    king = board.piece_on(from)
    king.valid_move?(from, to).should be_false
  end

  it "determines if a castle is possible" do
    king_position = make_square(4, 0)
    left_rook_position = make_square(0, 0)
    right_rook_position = make_square(7, 0)
    king = board.piece_on(king_position)
    king.castle?(king_position, left_rook_position).should be_false
    king.castle?(king_position, right_rook_position).should be_false
  end

  it "determines if it is safe from its position" do
    king_position = make_square(4, 0)
    king = board.piece_on(king_position)
    king.safe_from?(king_position).should be_true
  end

  it "determines if it is attacked by a pawn" do
    king_position = make_square(4, 7)
    king = board.piece_on(king_position)
    king.attacked_by_a_pawn?(king_position).should be_false
  end

  it "determines if it is attacked by a knight" do
    king_position = make_square(4, 7)
    king = board.piece_on(king_position)
    king.attacked_by_a_knight?(king_position).should be_false
  end 

  it "determines if it is attacked by something else" do
    king_position = make_square(4, 7)
    king = board.piece_on(king_position)
    king.attacked_by_other?(king_position).should be_false
  end

  it "moves like a king" do
    from = make_square(4, 7)
    to = make_square(4, 5)
    king = board.piece_on(from)
    king.move(from, to).should be_false
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
    from = make_square(0, 6)
    to = make_square(0, 4)
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

  it "can switch players" do
    board.turn.should eq "white"
    board.switch_players
    board.turn.should eq "black"
    board.switch_players
    board.turn.should eq "white"
  end

  it "determines if the current player owns a piece on a given position" do
    square1 = make_square(0, 0)
    board.player_owns_piece_on?(square1).should be_false
    square2 = make_square(4, 7)
    board.player_owns_piece_on?(square2).should be_true
  end

  it "determines if the current player is allowed to move a piece on a given position" do
    from = make_square(1, 7)
    to = make_square(0, 5)
    board.allowed_to_move_piece_on?(from, to).should be_true
  end

  it "determines if game is over" do
    board.game_over?.should be_false
  end

  it "players can move as expected" do
    from = make_square(4, 6)
    to = make_square(4, 5)
    board.make_a_move(from, to)
    check_rendering_of board, '
      ♜♞♝♛♚♝♞♜
      ♟♟♟♟♟♟♟♟
      --------
      --------
      --------
      ----♙---
      ♙♙♙♙-♙♙♙
      ♖♘♗♕♔♗♘♖
    '
  end

  it "gets game status as expected" do
    board.white_win?.should be_false
    board.black_win?.should be_false
    board.stalemate?.should be_false
  end

  it "determines if a pawn should be promoted" do
    board.promotion?.should be_false
  end
end

def make_square(*args)
  Square.new(*args)
end

def make_board
  ChessBoard.new
end

def make_piece(*args)
  Piece.new(*args)
end

def make_queen(*args)
  Queen.new(*args)
end

def make_bishop(*args)
  Bishop.new(*args)
end

def make_knight(*args)
  Knight.new(*args)
end

def make_pawn(*args)
  Pawn.new(*args)
end

def make_rook(*args)
  Rook.new(*args)
end

def make_king(*args)
  King.new(*args)
end

def check_rendering_of(board, expected)
  output = board.print
  output.should eq rendering(expected)
end

def rendering(text)
  text.strip.gsub(/^\s+/, '')
end