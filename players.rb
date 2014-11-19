class Player

  attr_reader :name

  def play_turn
  end
end

class HumanPlayer < Player
  def initialize(name)
    @name = name
  end

  def play_turn
    puts "Player #{@name}, input your move in algebraic notation (e.g. a2, a4):"
    print "> "
    gets.split(",").map { |el| el.strip }
  end
end
