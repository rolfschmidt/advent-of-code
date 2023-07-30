class Day06 < Helper
  def self.memory_count(nums)
    memory = []
    memory << nums.to_s

    loop do
      mv = nums.max
      mi = nums.index{|v| v == mv }
      nums[mi] = 0

      i = mi
      while mv > 0
        i = (i + 1) % nums.size
        nums[i] += 1
        mv -= 1
      end

      break if memory.include?(nums.to_s)
      memory << nums.to_s
    end

    [memory.count, nums]
  end

  def self.part1
    nums = file.split(/\s+/).map(&:to_i)
    memory_count(nums).first
  end
  
  def self.part2
    nums = file.split(/\s+/).map(&:to_i)
    memory_count(memory_count(nums).second).first
  end
end

RSpec.describe "Day06" do
  it "does part 1" do
    expect(Day06.part1).to eq(14029)
  end

  it "does part 2" do
    expect(Day06.part2).to eq(2765)
  end
end