require './board.rb'

if $PROGRAM_NAME == __FILE__
  chess = Board.new
  puts chess.render
end
