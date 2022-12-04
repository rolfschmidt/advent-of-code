class Day03 < Helper
  def self.part1
    result = []
    file.split("\n").each do |line|
      p1, p2 = line.halve.map(&:chars)

      result += (p1 & p2).map{|c| all_chars.index(c) + 1 }
    end

    result.sum
  end

  def self.part2
    result = []
    file.split("\n").each_slice(3).each do |groups|
      p1, p2, p3 = groups.map(&:chars)

      result += (p1 & p2 & p3).map{|c| all_chars.index(c) + 1 }
    end

    result.sum
  end
end

RSpec.describe "Day03" do
  it "does part 1" do
    expect(Day03.part1).to eq(8252)
  end

  it "does part 2" do
    expect(Day03.part2).to eq(2828)
  end
end