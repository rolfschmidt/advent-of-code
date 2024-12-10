class Day10 < Helper
  def self.part1(part2 = false)
    map = file.to_map.map_values(&:to_i)

    map.reverse[0].sum do |start, si|
      stop_on = -> (map, start, path) do
        map[start] == 9
      end

      skip_on = -> (map, start, pos, path) do
        map[pos] != map[start] + 1
      end

      result = map.find_paths(start, stop_on: stop_on, skip_on: skip_on)
      if part2
        result[:total]
      else
        result[:total_destinations]
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
