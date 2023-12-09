class Day02 < Helper
  def self.part1
    file.split("\n").sum do |line|
      nums = line.numbers
      data = [nums[0] * nums[1], nums[1] * nums[2], nums[2] * nums[0] ]

      data.map{|v| v * 2}.sum + data.min
    end
  end

  def self.part2
    file.split("\n").sum do |line|
      nums = line.numbers
      (2 * [ nums[0] + nums[1], nums[1] + nums[2], nums[2] + nums[0] ].min) + nums.inject(:*)
    end
  end
end

RSpec.describe "Day02" do
  it "does part 1" do
    expect(Day02.part1).to eq(1606483)
  end

  it "does part 2" do # 3858306
    expect(Day02.part2).to eq(3842356)
  end
end
