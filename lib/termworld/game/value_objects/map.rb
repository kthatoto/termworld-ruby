module Termworld
  class Map
    def name
      MAP_NAME
    end

    def chip_numbers
      return @chip_numbers_lines if @chip_numbers_lines
      @chip_numbers_lines = CHIP_NUMBERS_LINES.lines(chomp: true)
        .map { |chip_numbers_line| chip_numbers_line.split }
      @chip_numbers_lines
    end

    def get_chip(y:, x:)
      chip_number = chip_numbers[y] && chip_numbers[y][x]
      return nil if chip_number.nil?
      chip = Resources::Chip.new(y: y, x: x, key: chip_number)
      chip
    end
  end
end
