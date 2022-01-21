require_relative 'board.rb'

class Game

    def initialize(size=9, chance=0.1)
        @board = Board.new(size, chance)
        @game_over = false
    end

end