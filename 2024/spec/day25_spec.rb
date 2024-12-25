class Day25 < Helper
  def self.part1(part2 = false)
    schemas = file.blocks.map(&:to_map)
    keys    = schemas.select { _1[Vector.new(0,0)] == '#' }
    locks   = schemas.select { _1[Vector.new(_1.minx, _1.maxy)] == '#' }

    keys.sum do |key_map|
      locks.sum do |lock_map|
        match = true
        lock_map.each do |key, value|
          next if value != '#'
          next if key_map[key] == '.'

          match = false
          break
        end

        match ? 1 : 0
      end
    end
  end
end

RSpec.describe "Day25" do
  it "does part 1" do
    expect(Day25.part1).to eq(2770)
  end
end