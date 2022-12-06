class Day06 < Helper
  def self.part1(range = 3)
    chs = file.chars
    chs.each_with_index do |chars, i|
      next if chs[i - range..i].uniq.count != range + 1
      return i + 1
    end
  end

  def self.part2
    part1(13)
  end
end

RSpec.describe "Day06" do
  it "does part 1" do
    expect(Day06.part1).to eq(1760)
  end

  it "does part 2" do
    expect(Day06.part2).to eq(2974)
  end
end