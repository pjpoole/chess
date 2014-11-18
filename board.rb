require "./pieces.rb"
require "./chess_errors.rb"


class Board
  SIZE = 8
  ALGEBRAIC = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h:7 }
  COLORS = {w: "white", b: "black"}

  attr_reader :board

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE) }
    populate
    @captured_pieces = []
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
    color == :w  ? (opp_color = :b) : (opp_color = :w)
    enemy_pieces = []

    @board.each do |row|
      row.each do |cell|
        enemy_pieces << cell if cell.color == opp_color
        king_pos = cell.pos if cell.is_a?(King) && cell.color == color
      end
    end

    enemy_pieces.each do |piece|
      return true if piece.moves.include?(king_pos)
    end

    false
  end

  def move(start, end_pos)
    # There are three different modes for referencing cells.
    # @board[y][x] for methods within Board EXCEPT:
    # @board[x][y] for the render method.
    # From outside Board, board[[x,y]] is the call.

    x_start, y_start = clean_pos(start)
    x_end, y_end = clean_pos(end_pos)

    p x_start
    p y_start
    piece = @board[y_start][x_start]
    p piece.class

    raise "No piece at start location" if piece.nil?

    raise unless piece.moves([x_start, y_start]).include?([x_end, y_end])


    @captured_pieces << @board[y_end][x_end] unless @board[y_end][x_end].nil?
    @board[y_start][x_start] = nil
    @board[y_end][x_end] = piece
    piece.pos = [x_end, y_end]
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

  def clean_pos(pos)
    clean_pos = pos[0..1].downcase
    x, y = ALGEBRAIC[pos[0].to_sym], (pos[1].to_i - 1)

    raise "Invalid input" unless x.between?(0, 7) || y.between?(0, 7)
    [x, y]
  end

end
