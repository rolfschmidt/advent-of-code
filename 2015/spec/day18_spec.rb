class Day18 < Helper
  def self.part1(part2 = false)
    map = file.to_map

    always_on = [
      Vector.new(map.minx, 0),
      Vector.new(map.maxx, 0),
      Vector.new(map.minx, map.maxy),
      Vector.new(map.maxx, map.maxy),
    ].to_set

    if part2
      always_on.each do |pos|
        map[pos] = '#'
      end
    end

    100.times do
      new_map = map.dup
      map.each do |pos, value|

        on = 0
        map.steps(pos, DIRS_ALL).each do |pos2|
          next if map[pos2] != '#'

          on += 1
        end

        next if part2 && always_on.include?(pos)

        if map[pos] == '#'
          if ![2, 3].include?(on)
            new_map[pos] = '.'
          end
        elsif map[pos] == '.'
          if on == 3
            new_map[pos] = '#'
          end
        end
      end
      map = new_map
    end

    map.select_value('#').count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day18" do
  it "does part 1" do
    expect(Day18.part1).to eq(814)
  end

  it "does part 2" do
    expect(Day18.part2).to eq(924)
  end
end