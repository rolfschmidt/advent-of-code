class Day01 < Helper
  def self.part1
    file_string.split("\n\n").map{|e| e.split("\n").map(&:to_i).sum }.max
  end

  def self.part2
    file_string.split("\n\n").map{|e| e.split("\n").map(&:to_i).sum }.sort.reverse[0,3].sum
  end
end

RSpec.describe "Day01" do
  it "does part 1" do
    expect(Day01.part1).to eq(72240)
  end

  it "does part 2" do
    expect(Day01.part2).to eq(210957)
  end
end