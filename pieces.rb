class Piece
  def initialize(board, pos)
    @board = board
    @pos = pos
  end

  def moves
    raise "Should never be here."
  end

end


class SlidingPiece < Piece
  def move_dirs
  end

  def moves
  end
end

class SteppingPiece < Piece
  def move_dirs
  end

  def moves
  end
end


class Queen < SlidingPiece
  def move_dirs
  end

  def moves
  end
end

class Bishop < SlidingPiece
  def move_dirs
  end

  def moves
  end
end

class Rook < SlidingPiece
  def move_dirs
  end

  def moves
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


  def moves
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

  def moves
  end
end


class Pawn < Piece
end
