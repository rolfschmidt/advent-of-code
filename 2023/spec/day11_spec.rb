class Day11 < Helper
  def self.part1(part2 = false)
    map       = file.to_2d
    locations = map.select_vec('#')

    ydot = map.keys.select {|i| map[i].exclude?('#') }
    map  = map.transpose
    xdot = map.keys.select {|i| map[i].exclude?('#') }

    locations = locations.map do |location|
      location.x += xdot.count{|x| x < location.x } * (part2 ? 1000000 - 1 : 1)
      location.y += ydot.count{|y| y < location.y } * (part2 ? 1000000 - 1 : 1)
      location
    end

    locations.combination(2).sum do |a, b|
      a.manhattan(b)
    end
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
