class Day10 < Helper
  def self.trails(map, start, path = [])
    result = []

    height = map[start]
    if height == 9
      result << path
      return result
    end

    map.steps(start, DIRS_PLUS).each do |pos|
      pos_path = path.dup
      next if map[pos] != height + 1
      next if pos_path.include?(pos)
      pos_path << pos

      result += trails(map, pos, pos_path)
    end
    result
  end

  def self.part1(part2 = false)
    map = file.to_map.map_values(&:to_i)

    map.reverse[0].sum do |start, si|
      result = trails(map, start, [start])
      if part2
        result.count
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