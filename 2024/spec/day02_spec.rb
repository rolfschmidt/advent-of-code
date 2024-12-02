class Day02 < Helper
  def self.check(data)
    diffs = data.each_cons(2).map { _2 - _1 }
    diffs.all?{ [1, 2, 3].include?(_1) } || diffs.all?{ [-1, -2, -3].include?(_1) }
  end

  def self.part1(part2 = false)
    file.lines.sum do |row|
      data = row.split.map(&:to_i)

      next 1 if check(data)
      next data.combination(data.size - 1).any? { check(_1) }.to_i if part2
      0
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day02" do
  it "does part 1" do
    expect(Day02.part1).to eq(359)
  end

  it "does part 2" do
    expect(Day02.part2).to eq(418)
  end
end