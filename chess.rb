require './board.rb'
require './players.rb'
require './chess_errors.rb'


class Chess

  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new("Peter")
    @player2 = HumanPlayer.new("Anthony")
  end

  def play
    system "clear"
    color = :w
    white_current_player = true

    # begin
    until game_over?(color)
      puts @board.render
      player = white_current_player ? @player1 : @player2

      begin
        process_move(player.play_turn, color)
      rescue ChessError => e
        puts "Invalid move: #{e.message}"
        retry
      end
      sleep(1)

      system "clear"

      white_current_player = !white_current_player
      color = white_current_player ? :w : :b
    end

    puts "Game Over!"
    puts "Congrats #{ @white_current_player ? @player1.name : @player2.name }!"
  end


  private

  def process_move(move, color)
    raise ChessError.new('Attempt to move opponent\'s piece') if
          color != @board.check_color(move[0])
    @board.move(move[0], move[1])
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
