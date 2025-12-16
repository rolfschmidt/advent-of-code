class Day01 < Helper
  def self.fuel(mass, deep = false)
    result = ((mass / 3) - 2).floor
    return 0 if result < 0

    result += fuel(result, deep) if deep
    result
  end

  def self.part1
    file.numbers.sum do |mass|
      fuel(mass, part2?)
    end
  end

  def self.part2
    part1
  end
end

RSpec.describe "Day01" do
  it "does part 1" do
    expect(Day01.part1).to eq(3363760)
  end

  it "does part 2" do
    expect(Day01.part2).to eq(5042767)
  end
end
