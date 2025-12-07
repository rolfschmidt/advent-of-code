class Day07 < Helper
  def self.map
    @map ||= file.to_map
  end

  def self.start
    @start ||= map.select_value('S').keys.first
  end

  def self.tachyons
    @tachyons ||= map.select_value('^').keys
  end

  def self.part1
    count = 0
    queue = [start]
    seen = Set.new
    while queue.present?
      pos = queue.shift
      next if seen.include?(pos)
      seen << pos

      if map[pos + DIR_DOWN] == '.'
        queue << pos + DIR_DOWN
      elsif map[pos + DIR_DOWN] == '^'
        count += 1
        queue << pos + DIR_DOWN + DIR_LEFT
        queue << pos + DIR_DOWN + DIR_RIGHT
      end
    end

    count
  end

  def self.count_timelines(map, pos)
    cache(pos) do
      next_tachy = tachyons.find { _1.x == pos.x && _1.y > pos.y }
      if next_tachy
        pos = next_tachy + DIR_UP
      end

      result = 0
      if map.maxy == pos.y
        result = 1
      elsif map[pos + DIR_DOWN] == '.'
        result = count_timelines(map, pos + DIR_DOWN)
      elsif map[pos + DIR_DOWN] == '^'
        result += count_timelines(map, pos + DIR_DOWN + DIR_LEFT)
        result += count_timelines(map, pos + DIR_DOWN + DIR_RIGHT)
      end
      result
    end
  end

  def self.part2
    count_timelines(map, start)
  end
end

RSpec.describe "Day07" do
  it "does part 1" do
    expect(Day07.part1).to eq(1587)
  end

  it "does part 2" do
    expect(Day07.part2).to eq(5748679033029)
  end
end
