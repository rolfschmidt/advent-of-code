Monkey = Struct.new(:id, :items, :operation, :diff, :true_monkey, :false_monkey, :part2) do
  attr_accessor :inspections

  def initialize(*)
    super
    @inspections = 0
  end

  def throw(divisor)
    result = {}
    while items.present?
      item = items.shift

      item = eval(operation.gsub("old", item.to_s))
      if part2
        item %= divisor
      else
        item = (item /  3).to_i
      end

      if item % diff == 0
        result[true_monkey] ||= []
        result[true_monkey] << item
      else
        result[false_monkey] ||= []
        result[false_monkey] << item
      end

      @inspections += 1
    end
    result
  end
end

class Day11 < Helper
  def self.part1(part2 = false)
    monkeys = file.scan(/(\d+).*?items: (.*?)\n.*?(old (?:\*|\+) (?:\d+|old)).+?(\d+).+?(\d+).+?(\d+)/mi).map do |monkey_split|
      Monkey.new(
        monkey_split[0].to_i,
        monkey_split[1].split(", ").map(&:to_i),
        monkey_split[2], monkey_split[3].to_i,
        monkey_split[4].to_i,
        monkey_split[5].to_i,
        part2
      )
    end

    divisor = 1
    monkeys.map(&:diff).map{|v| divisor = divisor.lcm(v) }

    (part2 ? 10000 : 20).times do
      monkeys.each do |monkey|
        monkey.throw(divisor).each do |to_monkey, items|
          monkeys[to_monkey].items += items
        end
      end
    end

    monkeys.map(&:inspections).sort.last(2).inject(:*)
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day11" do
  it "does part 1" do
    expect(Day11.part1).to eq(120756)
  end

  it "does part 2" do
    expect(Day11.part2).to eq(39109444654)
  end
end