class Day05 < Helper
  def self.part1
    file.split("\n").select do |line|
      ['a', 'e', 'i', 'o','u'].map{|c| line.count(c) }.sum > 2 && line.match(/(\w)\1/) && ['ab', 'cd', 'pq', 'xy'].none?{|v| line.include?(v) }
    end.count
  end

  def self.part2
    file.split("\n").select do |line|
      line.scan(/(\w\w).*(\1)/).present? && line.match(/(\w)\w\1/).present?
    end.count
  end
end

RSpec.describe "Day05" do
  it "does part 1" do
    expect(Day05.part1).to eq(238)
  end

  it "does part 2" do # 27 81
    expect(Day05.part2).to eq(69)
  end
end
