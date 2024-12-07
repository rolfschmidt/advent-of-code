class Day07 < Helper
  def self.calc(nums, value = 0, result, part2)
    return value == result if nums.blank?

    new = nums.shift
    return calc(nums.dup, value + new, result, part2) || calc(nums.dup, (value || 1) * new, result, part2) || calc(nums.dup, (value == 0 ? new : "#{value}#{new}".to_i), result, part2) if part2
    return calc(nums.dup, value + new, result, part2) || calc(nums.dup, (value || 1) * new, result, part2)
  end

  def self.part1(part2 = false)
    file.lines.map(&:numbers).sum do |nums|
      result = nums.shift
      next 0 if !calc(nums.dup, 0, result, part2)

      result
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day07" do
  it "does part 1" do
    expect(Day07.part1).to eq(20281182715321)
  end

  it "does part 2" do
    expect(Day07.part2).to eq(159490400628354)
  end
end