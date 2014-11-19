require "./pieces.rb"
require "./chess_errors.rb"


class Board
  SIZE = 8
  ALGEBRAIC = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h:7 }
  COLORS = {w: "white", b: "black"}

  attr_reader :board

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE) }
    @captured_pieces = []
  end

  def deep_dup
    dupe = Board.new

    @board.each_with_index do |row, x|
      row.each_with_index do |el, y|
        next if el.nil?
        dupe.board[x][y] = dup_piece(dupe, el)
      end
    end

    dupe
  end

  def dup_piece(board, element)
    dup_pos = element.pos
    dup_color = element.color

    element.class.new(board, dup_pos, dup_color)
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

  def checkmate?(color)
    return false unless in_check?(color)

    @board.each do |row|
      row.each do |cell|
        next if cell.nil?
        if cell.color == color
          return false unless cell.valid_moves.empty?
        end
      end
    end

    true
  end

  def in_check?(color)
    color == :w  ? (opp_color = :b) : (opp_color = :w)
    enemy_pieces = []
    king_pos = nil

    @board.each do |row|
      row.each do |cell|
        next if cell.nil?
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
    # Accepts inputs of the form "a1"

    # There are three different modes for referencing cells.
    # @board[y][x] for methods within Board EXCEPT:
    # @board[x][y] for the render method.
    # From outside Board, board[[x,y]] is the call.

    start_array = clean_pos(start)
    end_array = clean_pos(end_pos)

    coord_move(start_array, end_array)
  end

  def check_color(pos)
    x, y = clean_pos(pos)

    @board[y][x].color
  end

  def coord_move(start, end_pos)
    # Accepts inputs of the form [x, y]
    piece = @board[start[1]][start[0]]

    raise "No piece at start location" if piece.nil?
    raise "Move would put player in check" unless piece.valid_moves.include?([end_pos[0], end_pos[1]])

    update_pos(start, end_pos)
  end

  def coord_move!(start, end_pos)
    piece = @board[start[1]][start[0]]

    raise if piece.nil? # should never happen
    raise "Invalid destination" unless piece.moves.include?([end_pos[0], end_pos[1]])

    update_pos(start, end_pos)
  end

  def update_pos(start, end_pos)
    x_start, y_start = start
    x_end, y_end = end_pos
    piece = @board[y_start][x_start]

    @captured_pieces << @board[y_end][x_end] unless @board[y_end][x_end].nil?
    @board[y_end][x_end] = piece
    piece.pos = [x_end, y_end]
    @board[y_start][x_start] = nil
  end

  def populate
    COLORS.keys.each do |color|
      populate_pawns(color)
      populate_others(color)
    end

    self
  end

  # Output functions
  def render
    render =""
    SIZE.downto(1) do |idx|
      render << idx.to_s
      x = idx - 1
      SIZE.times do |y|
        @board[x][y].nil? ? (render << " ") : (render << @board[x][y].yield_char)
        render << " "
      end
      render << "\n"
    end

    render << " A B C D E F G H"
  end

  def place(piece_symbol, pos, color)
    x, y = clean_pos(pos)
    new_pos = [x, y]

    # TODO: can you do @board[y][x] = case when   ??
    case piece_symbol
    when :P
      @board[y][x] = Pawn.new(self, new_pos, color)
    when :Q
      @board[y][x] = Queen.new(self, new_pos, color)
    when :K
      @board[y][x] = King.new(self, new_pos, color)
    when :B
      @board[y][x] = Bishop.new(self, new_pos, color)
    when :R
      @board[y][x] = Rook.new(self, new_pos, color)
    when :N
      @board[y][x] = Knight.new(self, new_pos, color)
    end
  end

  # Private functions below
  private

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

    raise "Input out of bounds" unless x.between?(0, 7) || y.between?(0, 7)
    [x, y]
  end

end
