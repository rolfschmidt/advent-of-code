class Day01 < Helper
  def self.part1(part2 = false)
    100
  end

  def self.part2
    part1(true)
  end
end

puts Day01.part1
# puts Day01.part2
return

RSpec.describe "Day01" do
  it "does part 1" do
    expect(Day01.part1).to eq(100)
  end

  it "does part 2" do
    expect(Day01.part2).to eq(100)
  end
end
