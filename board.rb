require_relative 'tile.rb'
require 'colorize'
require 'byebug'

class Board
    attr_reader :size, :grid, :exploded
    def initialize(size, chance)
        @size = size
        @grid = Array.new(@size) { Array.new(@size) { Tile.new(chance) } }
        self.populate!
        true
        @exploded = false
    end

    def populate!
        (0...@size).each do |row|
            (0...@size).each do |col|

                tile = @grid[row][col]
                tile.get_neighboring_positions!(row, col, @size)

                tile.neighboring_positions.each do |position|
                    nrow, ncol = *position
                    neighbor = @grid[nrow][ncol]

                    tile.value += 1 if neighbor.bomb
                end

            end
        end

    end

    def render(godmode=false)
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
                else
                    tile.revealed ? (print "▢") : (print "▥")
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
        if tile.bomb # if tile is a bomb, game over.
            self.explode!
            break
        else
            tile.reveal!
        end

        if no_neighbor_bombs?(row, col)
            reveal_all_tile_neighbors(row, col)
        else
            
        end

    end

    def no_neighbor_bombs?(row, col) # if the tile at this position has no bombs adjacent
        tile = @grid[row][col]
        tile.neighboring_positions.none? do |position|
            nrow, ncol = *position
            ntile = @grid[nrow][ncol]
            ntile.bomb
        end
    end

    def reveal_all_tile_neighbors(row, col) # reveal the neighbors of the tile at this position
        tile = @grid[row][col]
        tile.neighboring_positions.each do |position|
            nrow, ncol = *position              
            ntile = @grid[nrow][ncol]
            ntile.reveal!
        end
    end

    def explode!
        @exploded = true
    end

end