class Day03 < Helper
  def self.part1(part2 = false)
    on = true
    file.scan(/(do\(\)|don\'t\(\)|mul\((-?\d+),(-?\d+)\))/).sum do |match|
      if match[0].include?('do()')
        on = true
      elsif match[0].include?('don\'t')
        on = false
      elsif match[0].include?('mul') && (!part2 || (part2 && on))
        next match[1..].map(&:to_i).inject(:*)
      end
      0
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day03" do
  it "does part 1" do
    expect(Day03.part1).to eq(170807108)
  end

  it "does part 2" do
    expect(Day03.part2).to eq(74838033)
  end
end