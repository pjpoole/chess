require './board.rb'
require './players.rb'
require './chess_errors.rb'


class Chess

  def initialize
    @board = Board.new
    @board.populate
    @player1 = HumanPlayer.new("Peter")
    @player2 = HumanPlayer.new("Anthony")
  end

  def play
    white_current_player = true

    until game_over?

      puts @board.render
      player = white_current_player ? @player1 : @player2
      color = white_current_player ? :w : :b

      begin
        process_move(player.play_turn, color)
      rescue ChessError => e
        puts "Invalid move: #{e}"
        retry
      end
      sleep(1)

      system "clear"

      white_current_player = !white_current_player
    end

    puts "Game Over!"
    puts "Congrats #{ @white_current_player ? @player2.name : @player1.name }!"
  end


  private

  def process_move(move, color)
    @board.move(move[0], move[1]) if color == @board.check_color(move[0])
  end

  def game_over?(color)
    @board.checkmate?(color)
  end

  def get_player
    # puts "Who is player 1?"
    # gets.chomp looks for "h" or "c"
    # get their names, which will be used to address the players
  end
end


if $PROGRAM_NAME == __FILE__
  chess = Chess.new
  chess.play
end
