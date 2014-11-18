require "./pieces.rb"

class Board
  SIZE = 8
  COLORS = {w: "white", b: "black"}

  attr_reader :board

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE) }
    populate
  end

  def [](pos)
    x, y = pos
    @board[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @board[x][y] = piece
  end

  def populate
    COLORS.each do |color|
      populate_pawns(color)
      populate_others(color)
    end
  end

  def populate_pawns(color)
    color == :w ? offset = 1 : offset = 6
    #do pawns
    SIZE.times do |index|
      pos = [index, offset]
      @board[pos] = Pawn.new(self, pos, color)
    end
  end

  def populate_others(color)
    color == :w ? offset = 0 : offset = 7
    SIZE.times do |index|
      pos = [index, offset]
      case index
      when 0, 7
        @board[pos] = Rook.new(self, pos, color)
      when 1, 6
        @board[pos] = Knight.new(self, pos, color)
      when 2, 5
        @board[pos] = Bishop.new(self, pos, color)
      when 3
        @board[pos] = Queen.new(self, pos, color)
      when 4
        @board[pos] = King.new(self, pos, color)
      end
    end
  end

  def in_check?(color)

  end

  def move(start, end_pos)
  end
end
