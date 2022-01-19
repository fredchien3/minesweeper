require_relative 'tile.rb'

class Board
    attr_reader :size, :grid
    def initialize(size=9, chance=0.1)
        @size = size
        @grid = Array.new(@size) { Array.new(@size) { Tile.new(chance) } }
        self.populate!
        true
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
                    tile.bomb ? (print "B") : (print tile.value)
                else
                    tile.revealed ? (print "▢") : (print "▥")
                end
                print " "
            end
            puts
        end
        true
    end

    def xray
        self.render(true)
    end

    # def reveal_tile(row, col)
    #     tile = @grid[row][col]
    #     tile.reveal!
    #     tile.neighboring_positions.each do |position|
    #         nrow, ncol = *position
    #         reveal_tile(nrow, ncol)
    #     end
    # end

end