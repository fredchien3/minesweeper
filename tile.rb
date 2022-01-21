class Tile
    attr_reader :bomb, :revealed, :neighboring_positions
    attr_accessor :value

    def initialize(chance) # initializes the tile with a default 10% chance of bomb
        rand <= chance ? @bomb = true : @bomb = false
        @revealed = false
        @value = 0
        @neighboring_positions = Array.new
    end

    def reveal!
        @revealed = true
    end

    def get_neighboring_positions!(row, col, board_size)
        @neighboring_positions << [row-1, col-1]
        @neighboring_positions << [row-1, col]
        @neighboring_positions << [row-1, col+1]
        @neighboring_positions << [row, col-1]
        @neighboring_positions << [row, col+1]
        @neighboring_positions << [row+1, col-1]
        @neighboring_positions << [row+1, col]
        @neighboring_positions << [row+1, col+1]

        @neighboring_positions.select! do |position|
            position[0].between?(0, board_size-1) && position[1].between?(0, board_size-1)
        end
    end



end