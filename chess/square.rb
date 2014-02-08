class Square
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    x == other.x and y == other.y
  end

  def out_of_the_board?
    [x, y].any? { |coordinate| coordinate < 0 or coordinate > 7 }
  end

  def inside_the_board?
    not out_of_the_board?
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