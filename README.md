ruby-chess
==========

Description
-----------

Chess game written in Ruby

Requirements
------------

You should have Ruby 2.1.0 properly installed. I guess it might work with
older versions of Ruby so you can try that out but I can't guarantee anything.

If you want to run the tests, you'll have to install `rspec` and `bundler`. It is easy. Just
run the following command in terminal:

`gem install rspec`

`gem install bundler`

If you want to play the game with the GUI, you'll have to install `green_shoes`:

`gem install green_shoes`

Installation
------------

It is easy. Just type the following command in terminal:

`git clone https://github.com/MariaTerzieva/ruby-chess.git`

Afterwards you should have a folder ruby-chess somewhere on your PC.

Playing the game
----------------

### In the terminal:

1. Change your current directory to ruby-chess.
2. Run `ruby console_ui.rb`.

IMPORTANT: By move in chess notation I actually mean Smith notation but just
with source square and destination square without the captured piece.

More instructions will appear in the terminal.

### With the GUI:

1. Change your current directory to ruby-chess.
2. Run `ruby gui.rb`.

IMPORTANT: Here I assume that there are two players who play against each other
and the white should make the first move. Moving on the board is easy. Click on the
piece that you want to move and afterwards click on the destination square. If your
move is valid, the piece should move to the destination square. Otherwise just make
another move.

#### Saving/Loading the game:

Click on the `save` button and a new window with instuctions will appear. Type in the name
of the game and click `ok`. You will exit the game automatically by doing so.

To load a game click on the `load` button and type in a name of an *existing* saved game.

If you want to start a new game, just click on the button `new game`.

Running the tests
-----------------

If you want to run the tests, type the following command in terminal:

`bundle exec rake check`

Contribution
------------

In case you find any issues with this code, use the project's Issues page to report them
or send pull requests.

License
-------

Released under the MIT License.

TODO/Refractor
--------------

- Make the GUI and the console interface more user friendly
- Add methods `up`, `left`, `right`, `down` to Square
- Use squares for keys in the board
- Separate board and pieces logic as much as possible
- Instead of checking if a move is valid, find all valid moves
- Add `green_shoes` to the Gemfile
- Implement en passant and pawn promotion
- Split `spec.rb` into smaller specs
- Not to repeat myself in different functions
- Avoid "global" functions