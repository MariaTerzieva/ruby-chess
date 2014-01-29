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

  def make_square(*args)
    Square.new(*args)
  end
end