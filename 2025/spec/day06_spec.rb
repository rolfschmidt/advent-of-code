class Day06 < Helper
  def self.part1
    file.lines.map { _1.scan(/\+|\*|-?\d+/) }.transpose.sum do |line|
      op      = line.pop
      numbers = line.map(&:to_i)

      numbers.reduce { _1.send(op, _2) }
    end
  end

  def self.part2
    grid     = file.lines.map(&:chars)
    max_size = grid.map(&:size).max
    grid.each_with_index do |v, vi|
      (max_size - grid[vi].size).times do
        grid[vi].push(' ')
      end
    end

    row    = {}
    result = 0
    (grid.transpose + [['+']]).each do |line|
      if ['+', '*'].include?(line.last)
        if row.present?
          result += row[:numbers].compact.reduce { _1.send(row[:op], _2) }
        end
        row = { op: line.last, numbers: [] }
      end
      row[:numbers] << line.join('').numbers.first
    end

    result
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
