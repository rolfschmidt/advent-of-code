class Day06 < Helper
  def self.move(time, distance, boost)
    moved   = 0
    step    = [time, boost].min
    time   -= step
    moved   = time * step
    return moved
  end

  def self.part1(part2 = false)
    nums = file.split("\n").map do |line|
      if part2
        line.gsub(/\s+/, '').scan(/\d+/).map(&:to_i)
      else
        line.scan(/\d+/).map(&:to_i)
      end
    end

    total = []
    nums[0].zip(nums[1]).each do |time, distance|
      total << (1..time).count { |boost| move(time, distance, boost) > distance }
    end
    total.inject(:*)
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
