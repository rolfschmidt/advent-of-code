class Day02 < Helper
  def self.part1
    nums = file.split("\n").map{|r| r.split(' ').map(&:to_i) }

    nums.each_with_object({ count: 0 }) do |row, result|
      result[:count] += row.max - row.min
    end
  end

  def self.part2
    nums = file.split("\n").map{|r| r.split(' ').map(&:to_i) }

    nums.each_with_object({ count: 0 }) do |row, result|
      row.combination(2) do |a, b|
        r = [a, b].max % [a, b].min
        next if r != 0

        result[:count] += [a, b].max / [a, b].min
      end
    end
  end
end

RSpec.describe "Day02" do
  it "does part 1" do
    expect(Day02.part1).to eq({ count: 53978 })
  end

  it "does part 2" do
    expect(Day02.part2).to eq({ count: 314 })
  end
end