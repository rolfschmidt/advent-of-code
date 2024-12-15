class Day20 < Helper
  def self.part1
    target = file.to_i
    size   = target / 10

    counts = Array.new(size, 10)
    (2..size).each do |nn|
      (nn..size - 1).step(nn).each do |ii|
        counts[ii] += 10 * nn
      end
    end

    return counts.index { _1 >= target }
  end

  def self.part2
    target = file.to_i
    size   = target / 10

    counts = Array.new(size, 0)
    (1..size).each do |nn|
      counter = 0
      (nn..size - 1).step(nn).each do |ii|
        counts[ii] += 11 * nn
        counter += 1
        break if counter == 50
      end
    end

    return counts.index { _1 >= target }
  end
end

RSpec.describe "Day20" do
  it "does part 1" do
    expect(Day20.part1).to eq(665280)
  end

  it "does part 2" do
    expect(Day20.part2).to eq(705600) # 637560 665280 825660 928620
  end
end