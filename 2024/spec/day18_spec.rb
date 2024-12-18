class Day18 < Helper
  def self.part1(part2 = false)
    bytes     = file.lines.map(&:numbers).map(&:to_vec)
    grid_size = test? ? 6 : 70
    map       = Hash.init_map(grid_size)

    byte_times = test? ? 12 : 1024
    byte_times.times do |round|
      byte = bytes.shift
      map[byte] = '#'
    end

    skip_on = -> (map:, pos:, dir:, path:, seen:, data:) do
      next true if map[pos] == '#'

      false
    end

    shortest, shortest_path = map.shortest_path(map.start, map.stop, skip_on: skip_on)

    if part2
      while bytes.present?
        byte = bytes.shift
        map[byte] = '#'

        next if shortest_path.exclude?(byte.to_s)

        shortest, shortest_path = map.shortest_path(map.start, map.stop, skip_on: skip_on)
        return "#{byte.x},#{byte.y}" if shortest.blank?
      end
    end

    shortest_path.size - 1
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day18" do
  it "does part 1" do
    expect(Day18.part1).to eq(380)
  end

  it "does part 2" do
    expect(Day18.part2).to eq('26,50') # 34,68 22,49
  end
end