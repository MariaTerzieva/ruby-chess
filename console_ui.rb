require 'yaml/store'
require './chess.rb'

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

  def save_load_dialogue
    puts "Type the name of the game."
    print "> "
  end

  def save
    store = YAML::Store.new "./games.store"
    store.transaction do
      save_load_dialogue
      input = gets.chomp
      store[input] = @board
    end
  end

  def nonexistent?(game)
    game.nil?
  end

  def load
    store = YAML::Store.new "./games.store"
    store.transaction do
      save_load_dialogue
      input = gets.chomp
      store[input]
    end
  end

  def print_instructions
    puts "Type a move in chess notation(e.g. a2a3)."
    puts "Type 'quit' to exit the game."
    puts "Type 'save' to save the game."
    puts "Type 'load' to load a game."
    print "> "
  end   

  def play
    system "clear"

    if @board.game_status != "Game in progress."
      puts @board.game_status
      exit
    end

    print_turn_and_board
    print_instructions

    input = gets.chomp
    if input == "quit"
      exit
    elsif input == "save"
      save
    elsif input == "load"
      game = load
      while nonexistent? game
        game = load
      end
      @board = game
    else
      if invalid? input
        puts "Type a move in chess notation, please!"
        sleep 1
      else
        @board.make_a_move *coordinates_in_my_notation(input)
      end
    end

    play
  end
end

ConsoleUI.new(ChessBoard.new).play