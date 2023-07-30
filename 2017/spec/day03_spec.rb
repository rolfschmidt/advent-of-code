class Day03 < Helper
  def self.adjacent_sum(sums, x, y)
    result = 0
    [1, 0, -1].each do |rx|
      [1, 0, -1].each do |ry|
        next if x == 0 && y == 0

        result += sums["#{x + rx}_#{y + ry}"] || 0
      end
    end

    sums["#{x}_#{y}"] = result
    sums
  end

  def self.part1(part2 = false)
    i = 0
    ri = 0
    r = file.to_i - 1
    x = 0
    y = 0

    sums = {
      "0_0" => 1,
    }

    while i < r
      i.times do
        if i % 2 == 0
          x -= 1
        else
          x += 1
        end
        ri += 1
        sums = adjacent_sum(sums, x, y)
        return sums["#{x}_#{y}"] if sums["#{x}_#{y}"] > 361527 && part2
        return x.abs + y.abs if ri == r && !part2
      end
      
      i.times do
        if i % 2 == 0
          y -= 1
        else
          y += 1
        end
        sums = adjacent_sum(sums, x, y)
        ri += 1
        return sums["#{x}_#{y}"] if sums["#{x}_#{y}"] > 361527 && part2
        return x.abs + y.abs if ri == r && !part2
      end

      i += 1
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day03" do
  it "does part 1" do
    expect(Day03.part1).to eq(326)
  end

  it "does part 2" do
    expect(Day03.part2).to eq(363010)
  end
end