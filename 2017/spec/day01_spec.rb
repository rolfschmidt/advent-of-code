class Day01 < Helper
  def self.calc(part2 = false)
    nums = file.split('').map(&:to_i)

    step = 1
    if part2
      step = nums.count / 2
    end

    result = 0
    nums.each_with_index do |a, i|
      b = nums[(i + step) % nums.count]

      next if a != b

      result += a
    end
    result
  end

  def self.part1
    calc
  end

  def self.part2
    calc(true)
  end
end

RSpec.describe "Day01" do
  it "does part 1" do
    expect(Day01.part1).to eq(1228)
  end

  it "does part 2" do
    expect(Day01.part2).to eq(1238)
  end
end
