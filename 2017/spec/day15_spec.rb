class Day15 < Helper
  def self.part1
    a, b = file.scan(/\d+/).map(&:to_i)
    
    count = 0
    40_000_000.times do
      a *= 16807
      b *= 48271

      a %= 2147483647
      b %= 2147483647

      count += 1 if a.to_s(2)[-16..] == b.to_s(2)[-16..]
    end

    count
  end

  def self.part2
    a, b = file.scan(/\d+/).map(&:to_i)
    
    count = 0
    5_000_000.times do
      loop do
        a *= 16807
        a %= 2147483647
        break if a % 4 == 0
      end

      loop do
        b *= 48271
        b %= 2147483647
        break if b % 8 == 0
      end

      count += 1 if a.to_s(2)[-16..] == b.to_s(2)[-16..]
    end

    count
  end
end

RSpec.describe "Day15" do
  it "does part 1" do
    expect(Day15.part1).to eq(567)
  end

  it "does part 2" do
    expect(Day15.part2).to eq(323)
  end
end