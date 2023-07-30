class Day05 < Helper
  def self.part1(part2 = false)
    arr = file.split("\n").map(&:to_i)

    i = 0
    steps = 0
    while arr[i] != nil
      ai = arr[i]
      if ai >= 3 && part2
        arr[i] -= 1
      else
        arr[i] += 1
      end
      i += ai
      steps += 1
    end
    steps
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day05" do
  it "does part 1" do
    expect(Day05.part1).to eq(342669)
  end

  it "does part 2" do
    expect(Day05.part2).to eq(25136209)
  end
end