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

  attr_writer :pos
  attr_reader :color

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
  end

  def yield_char
    @print_char
  end

  def moves(pos)
    raise "Should never be here."

  end

  def empty?(pos)
    @board[pos].nil?
  end


  #return a boolean for whether the end move lands on a piece of opposite color
  def color_check?(pos)
    x, y = pos[0], pos[1]
    if !empty?([x, y])
      @board[[x, y]].color != color
    end
  end

end


class SlidingPiece < Piece


  def initialize(board, pos, color)
    super(board, pos, color)
    @deltas = DELTAS
  end

  def moves(pos)
    moves = []
    @deltas.each do |dx, dy|
      new_x, new_y = pos[0], pos[1]

      while true
        new_x += dx
        new_y += dy
        break unless (new_x).between?(0, 7) &&
                     (new_y).between?(0, 7)

        moves << [new_x, new_y]
        break if !empty?(move)
      end
    end

    moves.select { |move| color_check?(move) || empty?(move) }
  end
end

class SteppingPiece < Piece
  def move_dirs
  end

  def moves(pos)
    moves = []
    @deltas.each do |dx, dy|
      next unless (pos[0] + dx).between?(0, 7) && (pos[1] + dy).between?(0,7)

      moves << [pos[0] + dx, pos[1] + dy]
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

  def moves(pos)
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

  def moves(pos)
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

  def moves(pos)
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

  def moves(pos)
    moves = []
    x, y = pos

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
