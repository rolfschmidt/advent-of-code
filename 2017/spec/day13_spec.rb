class Day13 < Helper
  def self.part1(part2 = false)
    map = []
    file.split("\n").each do |line|
      row = line.split(": ").map(&:to_i)

      map << {
        pos: row.first,
        depth: row.second - 1
      }
    end

    if part2 
      10000000.times do |start|
        next if map.any? do |value|
          (value[:pos] + (0 - start).abs) % (value[:depth] * 2) == 0
        end

        return start
      end
    else
      return map.map do |value|
        if value[:pos] % (value[:depth] * 2) == 0
          value[:pos] * (value[:depth] + 1)
        else
          0
        end
      end.sum
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day13" do
  it "does part 1" do
    expect(Day13.part1).to eq(1632)
  end

  it "does part 2" do
    expect(Day13.part2).to eq(3834136)
  end
end