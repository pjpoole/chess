require './board.rb'
require "./chess_errors.rb"


class Chess

def play

  def initialize
    @board = Board.new.populate
    @player1 = get_player
    @player2 = get_player
    @white_current_player = true
  end

  def play
    until game_over?
      puts @board.render
      
      begin
        move = play_turn
        process_move(move)
      rescue ChessError => e
        puts "Invalid move: #{e}"
        retry
      end

      @white_current_player = !@white_current_player
    end
  end


  private

  def process_move(move)
    @white_current_player ? color = :w : color = :b

    @board.move(move[0], move[1]) if color == @board.check_color(move[0])
  end

  def win?(player)
    @board.checkmate?(player.color)
  end

  def game_over?
    win?(@player1) || win?(@player2)
  end

  def get_player
    # puts "Who is player 1?"
    # gets.chomp looks for "h" or "c"
    # get their names, which will be used to address the players
  end
end

end


if $PROGRAM_NAME == __FILE__
  chess = Board.new
  puts chess.render
end
