class Day12 < Helper
  def self.part1(part2 = false)
    map = file.to_map

    areas = []
    seen  = Set.new
    map.each do |pos, value|
      next if seen.include?(pos)

      result = map.flood(pos)

      areas |= [result]
      seen += result
    end

    result = 0
    areas.each do |area|
      edges = map.area_edges(area)

      if part2
        sides = map.area_sides(edges)
        result += area.count * sides.count
      else
        result += area.count * edges.count
      end
    end

    result
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(1381056)
  end

  it "does part 2" do
    expect(Day12.part2).to eq(834828) # 828594 839063
  end
end