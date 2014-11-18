class Piece
  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @print_char
  end

  def moves(pos)
    raise "Should never be here."

  end

  def empty?(pos)
    @board[pos].nil?
  end

end


class SlidingPiece < Piece
  def move_dirs
  end

  def moves(pos)
  end
end

class SteppingPiece < Piece
  def move_dirs
  end

  def moves(pos)
    moves = []
    DELTAS.each do |dx, dy|
      next unless (pos[0] + dx).between?(0, 7) && (pos[1] + dy).between?(0,7)
      next unless empty?(pos)

      moves << [pos[0] + dx, pos[1] + dy]
    end

    moves
  end
end


class Queen < SlidingPiece
  def move_dirs
  end

  def moves(pos)
  end
end

class Bishop < SlidingPiece
  def move_dirs
  end

  def moves(pos)
  end
end

class Rook < SlidingPiece
  def move_dirs
  end

  def moves(pos)
  end
end


class King < SteppingPiece
  DELTAS = [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0, -1],
    [ 0,  1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1]
  ]


  def moves(pos)

  end
end

class Knight < SteppingPiece
  DELTAS = [
    [-2, -1],
    [-2,  1],
    [ 2, -1],
    [ 2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2]
  ]

  def moves(pos)
  end
end


class Pawn < Piece
end
