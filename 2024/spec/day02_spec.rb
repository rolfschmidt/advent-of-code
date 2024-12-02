class Day02 < Helper
  def self.check(data)
    start = nil
    inc   = data.all?{|r| c = start.nil? || start < r; start = r; c }
    start = nil
    dec   = data.all?{|r| c = start.nil? || start > r; start = r; c }
    start = nil
    diff  = data.all?{|r| c = start.nil? || [1, 2, 3].include?((start - r).abs); start = r; c }

    (inc || dec) && diff
  end

  def self.part1(part2 = false)
    file.lines.sum do |row|
      data = row.split.map(&:to_i)

      next 1 if check(data)
      next data.combination(data.size - 1).any? {|row| check(row) }.to_i if part2
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