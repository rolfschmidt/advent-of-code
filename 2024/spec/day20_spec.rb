class Day20 < Helper
  def self.part1(cheat_dist = 2)
    map        = file.to_map
    start      = map.key('S')
    stop       = map.key('E')
    map[start] = '.'
    map[stop]  = '.'

    skip_on = -> (map:, pos:, dir:, path:, seen:, data:) do
      map[pos] == '#'
    end

    shortest, shortest_path = map.shortest_path(start, stop, skip_on: skip_on)

    shortest_path = shortest_path.map(&:to_vec)

    save_at_least = test? ? 50 : 100
    result        = 0
    shortest_path.keys.combination(2).each do |posai, posbi|
      posa = shortest_path[posai]
      posb = shortest_path[posbi]

      dist = posa.manhattan(posb)
      next if dist > cheat_dist

      normal_dist = shortest_path[posai..posbi].size - 1
      save_dist   = normal_dist - dist
      next if save_dist < save_at_least

      result += 1
    end

    result
  end

  def self.part2
    part1(20)
  end
end

RSpec.describe "Day20" do
  it "does part 1" do
    expect(Day20.part1).to eq(1445) # 5532
  end

  it "does part 2" do
    expect(Day20.part2).to eq(1008040) # 93576 13800 13860 884257
  end
end