class Day06 < Helper
  def self.move(time, distance, boost)
    step = [time, boost].min
    time -= step
    return time * step
  end

  def self.part1(part2 = false)
    nums = file.split("\n").map do |line|
      if part2
        line.gsub(/\s+/, '').numbers
      else
        line.numbers
      end
    end

    nums.inject(&:zip).map do |time, distance|
      (1..time).count { |boost| move(time, distance, boost) > distance }
    end.inject(:*)
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day06" do
  it "does part 1" do
    expect(Day06.part1).to eq(393120)
  end

  it "does part 2" do
    expect(Day06.part2).to eq(36872656)
  end
end
