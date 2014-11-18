require './board.rb'
require "./chess_errors.rb"


class Chess

def play

  begin
    # move
  rescue
    retry
  end

end

end


if $PROGRAM_NAME == __FILE__
  chess = Board.new
  puts chess.render
end
