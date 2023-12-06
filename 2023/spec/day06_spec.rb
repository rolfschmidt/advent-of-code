class Day06 < Helper
  def self.calc(time, distance, boost)
    moved   = 0
    step    = 0
    boost.times do |boost|
      step += 1
      time -= 1
      return moved if time == 0
    end
    while time > 0
      moved += step
      time -= 1
      return moved if time == 0
    end
    return moved
  end

  def self.part1(part2 = false)
    nums = file_test.split("\n").map do |line|
      if part2
        line.gsub(/\s+/, '').scan(/\d+/).map(&:to_i)
      else
        line.scan(/\d+/).map(&:to_i)
      end
    end

    total = []
    nums[0].zip(nums[1]).each do |time, distance|
      result = {}
      (1..time).each do |boost|
        moved = calc(time, distance, boost)
        next if moved <= distance

        result[boost] = moved
      end

      total << result.values.count
    end

    total.inject(:*)
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day06" do
  # it "does part 1" do
  #   expect(Day06.part1).to eq(100)
  # end

  it "does part 2" do
    expect(Day06.part2).to eq(100)
  end
end
