class Day05 < Helper
  def self.part1
    ranges, data = file.blocks.map(&:lines)
    ranges = ranges.map { _1.dash_pair.to_range }

    data.count { ranges.include_ranges?(_1) }
  end

  def self.part2
    ranges, data = file.blocks.map(&:lines)

    ranges.map { _1.dash_pair.to_range }.uniq_ranges.map(&:count).sum
  end
end

RSpec.describe "Day05" do
  it "does part 1" do
    expect(Day05.part1).to eq(712)
  end

  it "does part 2" do
    expect(Day05.part2).to eq(332998283036769)
  end
end
