class Day25 < Helper
  def self.search(x, y)
    n = y + x - 2
    rounds = (n * (n + 1)) / 2 + x - 1
    result = 20151125
    rounds.times do
      result = (result * 252533) % 33554393
    end
    result
  end

  def self.part1
    search(*file.numbers.reverse)
  end
end

RSpec.describe "Day25" do
  it "does part 1" do
    expect(Day25.part1).to eq(8997277)
  end
end
