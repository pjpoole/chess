require "./pieces.rb"

class Board
  SIZE = 8
  COLORS = {w: "white", b: "black"}

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE) }
  end

  def in_check?(color)
  end

  def move(start, end_pos)
  end
end
