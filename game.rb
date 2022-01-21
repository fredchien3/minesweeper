require_relative 'board.rb'

class Game

    def initialize(size=9, chance=0.1)
        @board = Board.new(size, chance)
        @size = size
        true
    end

    def play
        puts "Welcome to Ford Minesweeper!"
        while !self.game_over?
            @board.render
            pos = self.get_pos
            if pos[2] # if user wants to flag
                @board.flag_tile(*pos[0..1])
            else
                @board.reveal_tile(*pos[0..1])
            end
        end
        @board.render
        @board.exploded ? (puts "BOOM!") : (puts "Congratulations, you have located all the mines!")
        puts "Game over!"
    end

    def game_over?
        @board.exploded || @board.solved?
    end

    def get_pos
        puts "Please enter the position you would like to check, separated by a comma. E.g. 0, 0 f"
        puts "Add F if you want to flag or unflag."
        string = gets.chomp
        if string.include?("F") || string.include?("f")
            flag = true
            string.delete!("Ff")
        end

        if string.count(",") == 1
            array = string.split(",")
            row, col, flag = [array.first.to_i, array.last.to_i, flag]
            return [row, col, flag] if row.between?(0, @size-1) && col.between?(0, @size-1)
        end

        puts "Position invalid!"
        self.get_pos

    end

end

g = Game.new
g.play