class Day00 < Helper
  def self.part1(part2 = false)
    100
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day00" do
  it "does part 1" do
    expect(Day00.part1).to eq(100)
  end

  it "does part 2" do
    expect(Day00.part2).to eq(100)
  end
end