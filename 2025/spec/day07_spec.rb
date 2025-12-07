class Day07 < Helper
  def self.map
    @map ||= file.to_map
  end

  def self.start
    @start ||= map.select_value('S').keys.first
  end

  def self.part1
    count = 0
    queue = [start]
    seen = Set.new
    while queue.present?
      pos = queue.shift
      next if seen.include?(pos)
      seen << pos

      if map[pos.down] == '.'
        queue << pos.down
      elsif map[pos.down] == '^'
        count += 1
        queue << pos.down.left
        queue << pos.down.right
      end
    end

    count
  end

  def self.count_timelines(pos)
    cache(pos) do
      result = 0
      if map.maxy == pos.y
        result = 1
      elsif map[pos.down] == '.'
        result = count_timelines(pos.down)
      elsif map[pos.down] == '^'
        result += count_timelines(pos.down.left)
        result += count_timelines(pos.down.right)
      end
      result
    end
  end

  def self.part2
    count_timelines(start)
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
