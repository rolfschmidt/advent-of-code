class Day25 < Helper
  def self.part1(part2 = false)
    schemas = file.blocks.map(&:to_map)
    keys    = schemas.select { _1[Vector.new(0,0)] == '#' }
    locks   = schemas.select { _1[Vector.new(_1.minx, _1.maxy)] == '#' }

    result = 0
    keys.each do |key_map|
      locks.each do |lock_map|
        match = true
        lock_map.each do |key, value|
          next if value != '#'
          next if key_map[key] == '.'

          match = false
        end

        next if !match

        result += 1
      end
    end

    result
  end
end

RSpec.describe "Day25" do
  it "does part 1" do
    expect(Day25.part1).to eq(2770)
  end
end