class Day02 < Helper
  def self.default
    {
      'red'   => 0,
      'green' => 0,
      'blue'  => 0,
    }
  end

  def self.check
    {
      'red'   => 12,
      'green' => 13,
      'blue'  => 14,
    }
  end

  def self.part1(part2 = false)
    file.split("\n").sum do |line|
      game, sets = line.split(/\s*\:\s*/)

      possible = true
      usage_min = default
      sets.split(/\s*;\s*/).map{|s| s.split(', ') }.each do |round|

        usage = default
        round.map{|s| s.split(' ') }.each do |set|
          usage[set[1]] += set[0].to_i
          usage_min[set[1]] = [usage_min[set[1]], set[0].to_i].max
        end

        if check['red'] < usage['red'] || check['green'] < usage['green'] || check['blue'] < usage['blue']
          possible = false
        end
      end

      if part2
        usage_min.values.inject(:*)
      elsif possible
        game.scan(/\d+/).first.to_i
      else
        0
      end
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day02" do
  it "does part 1" do
    expect(Day02.part1).to eq(2449)
  end

  it "does part 2" do
    expect(Day02.part2).to eq(63981)
  end
end
