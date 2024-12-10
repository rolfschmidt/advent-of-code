class Day10 < Helper
  def self.trails(map, start, path = [])
    height = map[start].to_i
    return [path] if height == 9

    result = []
    map.steps(start, DIRS_PLUS).each do |pos|
      pos_path = path.dup
      next if map[pos].to_i != height + 1
      next if pos_path.include?(pos)
      pos_path << pos

      trails(map, pos, pos_path).each do |found|
        result << found
      end
    end
    result
  end

  def self.part1(part2 = false)
    map = file.to_map.reject_value('.')

    map.dup.reverse['0'].sum do |start, si|
      result = trails(map, start, [start])
      if part2
        result.map(&:last).count
      else
        result.map(&:last).uniq.count
      end
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day10" do
  it "does part 1" do
    expect(Day10.part1).to eq(512)
  end

  it "does part 2" do
    expect(Day10.part2).to eq(1045)
  end
end