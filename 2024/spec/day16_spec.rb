class Day16 < Helper
  def self.shortest_way(map, start, stop)
    total_seen   = Set.new

    stop_on = -> (map:, pos:, path:, seen:, data:, cost_min:) do
      print "."
      total_seen   = Set.new if cost_min != data[:cost]
      total_seen  += path.to_set
      return [ path.size, path, seen, data[:cost] ]
    end

    skip_on = -> (map:, pos:, dir:, path:, seen:, data:) do
      next true if map[pos] == '#'

      if data[:last_dir] == dir
        data[:cost] += 1
      else
        data[:cost] += 1001
      end

      data[:last_dir] = dir

      false
    end

    cost_min = map.shortest_path(start, stop, stop_on: stop_on, skip_on: skip_on, data: { last_dir: DIR_RIGHT, cost: 0 }).last

    {
      min: cost_min,
      seen: total_seen,
    }
  end

  def self.part1(part2 = false)
    map   = file.to_map
    start = map.select_value('S').keys.first
    stop  = map.select_value('E').keys.first

    @result ||= shortest_way(map, start, stop)

    return @result[:min] if !part2
    return @result[:seen].to_a.count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day16" do
  it "does part 1" do
    expect(Day16.part1).to eq(109496)
  end

  it "does part 2" do
    expect(Day16.part2).to eq(551)
  end
end