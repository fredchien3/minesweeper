require_relative 'tile.rb'
require 'colorize'
require 'byebug'

class Board
    attr_reader :size, :grid, :exploded
    def initialize(size=9, chance=0.1)
        @size = size
        @grid = Array.new(@size) { Array.new(@size) { Tile.new(chance) } }
        @non_bomb_tiles = Array.new
        @exploded = false
        self.populate!
    end

    def populate!
        (0...@size).each do |row|
            (0...@size).each do |col|
                tile = @grid[row][col]
                if !tile.bomb
                    @non_bomb_tiles << tile 
                end
                tile.get_neighboring_positions!(row, col, @size)
                tile.neighboring_positions.each do |position|
                    nrow, ncol = *position
                    neighbor = @grid[nrow][ncol]
                    tile.value += 1 if neighbor.bomb
                end
            end
        end
        true
    end

    def render(godmode=false)
        system("clear")
        
        print "  "
        (0..8).each do |num|
            print num
            print " "
        end
        puts 
        @grid.each_with_index do |row, i|
            print i.to_s + " "
            row.each do |tile|
                
                if godmode
                    tile.bomb ? (print "B".colorize(:red) ) : (print tile.value)

                elsif tile.flagged
                    print "F".colorize(:blue)
                elsif tile.revealed && tile.bomb
                    print "B".colorize(:red)
                elsif tile.revealed
                    tile.value == 0 ? (print "▢") : (print tile.value)
                else                    
                    print "▥"
                end
                
                print " "
            end
            puts
        end
        true
    end

    def display
        self.render(true)
    end

    def reveal_tile(row, col)
        tile = @grid[row][col]
        tile.reveal!

        if tile.bomb # if tile is a bomb, game over.
            self.explode!
        end
        
        return if tile.value > 0

        reveal_all_tile_neighbors(row, col)
    end

    def reveal_all_tile_neighbors(row, col)
        tile = @grid[row][col]
        tile.neighboring_positions.each do |position|
            nrow, ncol = *position              
            ntile = @grid[nrow][ncol]
            next if ntile.revealed
            reveal_tile(nrow, ncol)
        end
    end

    # def no_neighbor_bombs?(row, col)
    #     tile = @grid[row][col]
    #     tile.neighboring_positions.none? do |position|
    #         nrow, ncol = *position
    #         ntile = @grid[nrow][ncol]
    #         ntile.bomb
    #     end
    # end

    def flag_tile(row, col)
        tile = @grid[row][col]

        if tile.revealed
            puts "Tile is already revealed."
        else
            tile.flag!
        end
    end

    def explode!
        @exploded = true
    end

    def solved?
        @non_bomb_tiles.all? { |tile| tile.revealed }
    end

end