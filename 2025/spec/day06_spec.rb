class Day06 < Helper
  def self.part1
    file.lines.map { _1.scan(/\+|\*|-?\d+/) }.transpose.sum do |line|
      op = line.pop
      line.map(&:to_i).reduce(op)
    end
  end

  def self.part2
    grid      = file.lines.map(&:chars)
    grid_size = grid.map(&:size).max
    grid.map! do |row|
      row + Array.new(grid_size - row.size, ' ')
    end

    grid.transpose.map(&:join).map(&:strip).to_lines.blocks.sum do |block|
      op = block.include?('*') ? '*' : '+'
      block.numbers.reduce(op)
    end
  end
end

RSpec.describe "Day06" do
  it "does part 1" do
    expect(Day06.part1).to eq(6295830249262)
  end

  it "does part 2" do
    expect(Day06.part2).to eq(9194682052782)
  end
end
