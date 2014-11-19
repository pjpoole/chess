class Piece
  DELTAS = [
    [ 0, -1],
    [-1,  0],
    [ 0,  1],
    [ 1,  0],
    [-1, -1],
    [-1,  1],
    [ 1, -1],
    [ 1,  1]
  ]

  attr_accessor :pos
  attr_reader :color

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @board[pos] = self
  end

  def dup(board)
    self.class.new(board, @pos.dup , @color)
  end

  def to_s
    @print_char
  end

  def moves
    raise "Should never be here."
  end

  def empty?(pos)
    @board[pos].nil?
  end

  def valid_moves

    valid_moves = []
    self.moves.each do |move|
      valid_moves << move unless move_into_check?(move)
    end

    valid_moves
  end

  def move_into_check?(pos)
    duped_board = @board.dup

    duped_board.coord_move!(@pos, pos)
    duped_board.in_check?(@color)
  end


  #return a boolean for whether the end move lands on a piece of opposite color
  def color_check?(pos)
    x, y = pos[0], pos[1]
    if !empty?([x, y])
      @board[[x, y]].color != @color
    end
  end

end


class SlidingPiece < Piece


  def initialize(board, pos, color)
    super(board, pos, color)
    @deltas = DELTAS
  end

  def moves
    # Returns all moves regardless of whether it puts the board in check
    moves = []
    @deltas.each do |dx, dy|
      new_x, new_y = @pos

      while true
        new_x += dx
        new_y += dy
        break unless (new_x).between?(0, 7) &&
                     (new_y).between?(0, 7)

        moves << [new_x, new_y]
        break if !empty?([new_x, new_y])
      end
    end

    moves.select { |move| color_check?(move) || empty?(move) }
  end
end

class SteppingPiece < Piece
  def move_dirs
  end

  def moves
    moves = []
    x, y = @pos
    @deltas.each do |dx, dy|
      next unless (x + dx).between?(0, 7) && (y + dy).between?(0,7)

      moves << [x + dx, y + dy]
    end

    moves.select { |move| color_check?(move) || empty?(move) }
  end
end


class Queen < SlidingPiece

  def initialize(board, pos, color)
    super(board, pos, color)
    @print_char = "Q"
    @deltas = DELTAS
  end

  def move_dirs
  end
end

class Bishop < SlidingPiece

  def initialize(board, pos, color)
    super(board, pos, color)
    @print_char = "B"
    @deltas = DELTAS[4..7]
  end

  def move_dirs
  end
end

class Rook < SlidingPiece

  def initialize(board, pos, color)
    super(board, pos, color)
    @print_char = "R"
    @deltas = DELTAS[0..3]
  end

  def move_dirs
  end
end


class King < SteppingPiece

  def initialize(board, pos, color)
    super(board, pos, color)
    @print_char = "K"
    @deltas = DELTAS
  end

end

class Knight < SteppingPiece

  def initialize(board, pos, color)
    super(board, pos, color)
    @print_char = "N"
    @deltas = [
              [2, 1],
              [2, -1],
              [1, 2],
              [1, -2],
              [-1, 2],
              [-1, -2],
              [-2, 1],
              [-2, -1]
              ]
  end
end


class Pawn < Piece
  def initialize(board, pos, color)
    super(board, pos, color)
    @print_char = "P"
  end

  def moves
    moves = []
    x, y = @pos

    if color == :w
      if empty?([x, y + 1])
        moves << [x, y + 1]
        moves << [x, y + 2] if y == 1 && empty?([x, y + 2])
      end
      moves << [x + 1, y + 1] if color_check?([x + 1, y + 1])
      moves << [x - 1, y + 1] if color_check?([x - 1, y + 1])
    else
      if empty?([x, y - 1])
        moves << [x, y - 1]
        moves << [x, y - 2] if y == 6 && empty?([x, y - 2])
      end
      moves << [x - 1, y - 1] if color_check?([x - 1, y - 1])
      moves << [x + 1, y - 1] if color_check?([x + 1, y - 1])
    end

    moves
  end
end
