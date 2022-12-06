class Day06 < Helper
  def self.part1(range = 4)
    chars = file.chars
    chars.each_with_index do |_, i|
      next if chars[i - range + 1..i].uniq.count != range
      return i + 1
    end
  end

  def self.part2
    part1(14)
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