require "./chess.rb"

class ConsoleUI
  def initialize(board)
    @board = board
  end

  def prepend_rows
    rows = "87654321".chars
    @board.print.lines.map.with_index { |line, row| line.prepend rows[row] }.join
  end

  def board_with_rows_and_columns
    columns = " ABCDEFGH\n"
    prepend_rows.prepend columns
  end

  def print_turn_and_board
    puts "It is #{@board.turn}'s turn."
    puts board_with_rows_and_columns
  end

  def coordinates_in_my_notation(input)
    coordinates = input.downcase.chars.map.with_index do |char, index|
      index.even? ? (char.ord - 97) : (8 - char.to_i)
    end
    [Square.new(*coordinates[0..1]), Square.new(*coordinates[2..3])]
  end

  def invalid?(input)
    input.downcase.scan(/[a-h][1-8][a-h][1-8]/).length != 1
  end

  def play
    system("clear")
    if @board.game_status != "Game in progress."
      puts @board.game_status
      exit
    end
    print_turn_and_board
    puts "Type a move in chess notation(e.g. a2a3) or 'quit' to exit the game."
    print "> "
    input = gets.chomp
    exit if input == "exit"
    if invalid?(input)
      puts "Type a move in chess notation, please!"
      sleep(1)
    else
      @board.make_a_move(*coordinates_in_my_notation(input))
    end
    play
  end
end

ConsoleUI.new(ChessBoard.new).play