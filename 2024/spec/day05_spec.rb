class Day05 < Helper
  def self.sort(line, rules_map)
    old = line.clone
    line.each_with_index do |a, ai|
      line.each_with_index do |b, bi|
        next if bi <= ai

        if rules_map[a].include?(b)
          line.insert(ai - 1, line.delete_at(bi))
        end
      end
    end

    return sort(line, rules_map) if old != line
    line
  end

  def self.part1(part2 = false)
    rules, numbers = file.blocks
    rules          = rules.lines.map { _1.split('|').map(&:to_i) }
    numbers        = numbers.lines.map { _1.split(',').map(&:to_i) }

    rules_map = {}
    rules.each do |rule|
      rules_map[rule[0]] ||= []
      rules_map[rule[0]] |= [rule[1]]
    end

    numbers.sum do |line|
      valid = true
      line.each_with_index do |a, ai|
        line[..ai].each_with_index do |b, bi|
          if rules_map[a].include?(b)
            valid = false
          end
        end
      end

      if part2
        next 0 if valid
        line = sort(line, rules_map)
      else
        next 0 if !valid
      end

      line[line.size / 2]
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day05" do
  it "does part 1" do
    expect(Day05.part1).to eq(4774)
  end

  it "does part 2" do
    expect(Day05.part2).to eq(6004)
  end
end