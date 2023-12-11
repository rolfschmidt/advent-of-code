class Day11 < Helper
  def self.part1(part2 = false)
    map = file.split("\n").map(&:chars)

    locations = map.map.with_index do |y, yi|
      y.map.with_index do |x, xi|
        next if x != '#'

        Vector.new(xi, yi)
      end
    end.flatten.compact

    ydot = []
    map.each_with_index do |y, yi|
      if y.exclude?('#')
        ydot << yi
      end
    end

    map = map.transpose

    xdot = []
    map.each_with_index do |x, xi|
      if x.exclude?('#')
        xdot << xi
      end
    end

    locations = locations.map do |location|
      location.x += xdot.count{|x| x < location.x } * (part2 ? 1000000 - 1 : 1)
      location.y += ydot.count{|y| y < location.y } * (part2 ? 1000000 - 1 : 1)
      location
    end

    locations = locations.combination(2).map do |a, b|
      a.manhattan(b)
    end.sum
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day11" do
  it "does part 1" do
    expect(Day11.part1).to eq(10494813)
  end

  it "does part 2" do
    expect(Day11.part2).to eq(840988812853)
  end
end
