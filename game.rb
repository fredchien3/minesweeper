require_relative 'board.rb'

class Game

    def initialize(size=9, chance=0.1)
        @board = Board.new(size, chance)
        true
    end

    def play
        puts "Welcome to Ford Minesweeper!"

        while !self.game_over?
            @board.render
            pos = self.get_pos
            @board.reveal_tile(*pos)
        end

        @board.render
        puts "Congratulations, you have located all the mines!" if @board.solved?
        puts "Game over!"
    end

    def game_over?
        @board.exploded || @board.solved?
    end

    def get_pos
        puts "Please enter the position you would like to check, separated by a comma. E.g. 0,0"
        string = gets.chomp
        if string.count(",") == 1
            array = string.split(",")
        else
            puts "Position invalid!"
            self.get_pos
        end
        row, col = array.first.to_i, array.last.to_i
    end

end

g = Game.new
g.play