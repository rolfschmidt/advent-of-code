class Day03 < Helper
  def self.part1(part2: false)
    file.lines.sum do |line|
      line.chars.map(&:to_i).highest_number(2).join.to_i
    end
  end

  def self.part2
    file.lines.sum do |line|
      nums = line.chars.map(&:to_i).highest_number(12).join.to_i
    end
  end
end

RSpec.describe "Day03" do
  it "does part 1" do
    expect(Day03.part1).to eq(17330)
  end

  it "does part 2" do
    expect(Day03.part2).to eq(171518260283767)
  end
end
