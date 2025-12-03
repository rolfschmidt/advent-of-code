class Day03 < Helper
  def self.find_number(nums, max)
    result = ''
    li = 0
    while result.size < max do
      fi = nil
      fv = 0
      (li..(nums.size - (max - result.size))).each do |ci|
        if fv < nums[ci]
          fi = ci
          fv = nums[ci]
        end
      end

      result += fv.to_s
      li = fi + 1
    end
    result.to_i
  end

  def self.part1(part2: false)
    file.lines.sum do |line|
      nums = line.chars.map(&:to_i)

      find_number(nums, 2)
    end
  end

  def self.part2
    file.lines.sum do |line|
      nums = line.chars.map(&:to_i)

      find_number(nums, 12)
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
