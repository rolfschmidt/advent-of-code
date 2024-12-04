
class Day04 < Helper
  def self.part1(part2 = false)
    file.to_map.count_pattern('XMAS').count
  end

  def self.part2
    map = {}
    file.to_map.count_pattern('MAS', directions: DIRS_DIAG).each do |row|
      map[row[:list][1]] ||= []
      map[row[:list][1]] << row
    end

    map.count do |key, value|
      value.count == 2
    end
  end
end

RSpec.describe "Day04" do
  it "does part 1" do
    expect(Day04.part1).to eq(2534)
  end

  it "does part 2" do
    expect(Day04.part2).to eq(1866)
  end
end
