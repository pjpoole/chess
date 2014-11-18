require "./pieces.rb"

class Board
  SIZE = 8
  COLORS = {w: "white", b: "black"}

  attr_reader :board

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE) }
    populate
  end

  #just here so that we don't output @board in pry
  # def inspect
  # end

  def [](pos)
    x, y = pos
    @board[y][x]
  end

  def []=(pos, piece)
    x, y = pos
    @board[y][x] = piece
  end

  def in_check?(color)

  end

  def move(start, end_pos)
  end

  # Output functions
  def render
    render =""
    SIZE.downto(1) do |idx|
      render << idx.to_s
      x = idx - 1
      SIZE.times do |y|
        @board[x][y].nil? ? render << " " : render << @board[x][y].yield_char.concat(" ")
      end
      render << "\n"
    end

    render << " A B C D E F G H"
  end

  # Private functions below
  private
  def populate
    COLORS.keys.each do |color|
      populate_pawns(color)
      populate_others(color)
    end
  end

  def populate_pawns(color)
    color == :w ? offset = 1 : offset = 6
    #do pawns
    SIZE.times do |index|
      pos = [index, offset]
      @board[offset][index] = Pawn.new(self, pos, color)
    end
  end

  def populate_others(color)
    color == :w ? offset = 0 : offset = 7
    SIZE.times do |index|
      pos = [index, offset]
      case index
      when 0, 7
        @board[offset][index] = Rook.new(self, pos, color)
      when 1, 6
        @board[offset][index] = Knight.new(self, pos, color)
      when 2, 5
        @board[offset][index] = Bishop.new(self, pos, color)
      when 3
        @board[offset][index] = Queen.new(self, pos, color)
      when 4
        @board[offset][index] = King.new(self, pos, color)
      end
    end
  end

end
