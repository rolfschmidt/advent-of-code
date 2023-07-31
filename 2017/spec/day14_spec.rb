require 'day10'

class Day14 < Helper
  def self.squares
    @squares ||= begin
      result = []
      128.times do |i|
        result << Day10.part1(true, "#{file}-#{i}").to_i(16).to_s(2).rjust(128, '0')
      end
      result
    end
  end

  def self.part1
    squares.map{|v| v.count('1') }.sum
  end

  def self.find_max(x, y)
    return 0 if x < 0 || y < 0
    return 0 if !@map.dig(y, x)
    return 0 if @map[y][x] != "1"

    @seen ||= {}
    return 0 if @seen["#{y}_#{x}"]
    @seen["#{y}_#{x}"] = true

    result = 1
    result += find_max(x + 1, y)
    result += find_max(x - 1, y)
    result += find_max(x, y + 1)
    result += find_max(x, y - 1)
    result
  end

  def self.part2
    @map = squares.map{|v| v.split('') }

    max = 0
    @map.each_with_index do |yv, yi|
      yv.each_with_index do |xv, xi|
        max += 1 if find_max(xi, yi).positive?
      end
    end
    max
  end
end

RSpec.describe "Day14" do
  it "does part 1" do
    expect(Day14.part1).to eq(8204)
  end

  it "does part 2" do # 344 1112 1060
    expect(Day14.part2).to eq(1089)
  end
end