class Day01 < Helper
  def self.part1(part2 = false)
    al, bl = file.numbers.each_slice(2).to_a.transpose.map(&:sort)

    return al.sum do |a|
      a * bl.count(a)
    end if part2

    return al.map.with_index do |a, ai|
      (a - bl[ai]).abs
    end.sum
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day01" do
  it "does part 1" do
    expect(Day01.part1).to eq(1258579)
  end

  it "does part 2" do
    expect(Day01.part2).to eq(23981443)
  end
end