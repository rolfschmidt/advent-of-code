class Day11 < Helper
  def self.part1(part2 = false)
    check = file.numbers.to_h { [_1, 1] }

    @cache = {}
    (part2 ? 75 : 25).times do |i|
      new_check = check.dup

      check.each do |num, count|
        new_value = if num == 0
                      1
                    elsif num.to_s.length % 2 == 0
                      @cache[num] ||= num.to_s.halve.map(&:to_i)
                    else
                      num * 2024
                    end

        new_check[num] -= count
        Array.wrap(new_value).each do |vvv|
          new_check[vvv] ||= 0
          new_check[vvv] += count
        end
      end

      check = new_check
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