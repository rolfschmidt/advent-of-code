class Day01 < Helper
  def self.part1
    elves = []
    file_string.split("\n\n").each do |elve|
      elves << elve.split("\n").map(&:to_i).sum
    end

    elves.max
  end

  def self.part2
    elves = []
    file_string.split("\n\n").each do |elve|
      elves << elve.split("\n").map(&:to_i).sum
    end

    elves.sort.reverse[0,3].sum
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