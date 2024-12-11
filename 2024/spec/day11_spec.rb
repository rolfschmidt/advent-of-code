class Day11 < Helper
  def self.part1(part2 = false)
    check = file.numbers.to_h(1)

    (part2 ? 75 : 25).times do |i|
      check.clone.each do |num, count|
        new_values = if num == 0
                      [1]
                    elsif num.to_s.length % 2 == 0
                      num.to_s.halve.map(&:to_i)
                    else
                      [num * 2024]
                    end

        check[num] -= count
        new_values.each do |value|
          check[value] ||= 0
          check[value] += count
        end
      end
    end

    check.values.sum
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day11" do
  it "does part 1" do
    expect(Day11.part1).to eq(235850)
  end

  it "does part 2" do
    expect(Day11.part2).to eq(279903140844645)
  end
end