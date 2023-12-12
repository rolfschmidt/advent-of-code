class Day12 < Helper
  def self.search(value, numbers)
    return numbers.blank? ? 1 : 0 if value.blank?
    return value.index('#') ? 0 : 1 if numbers.blank?

    key = [value, numbers]
    @cache ||= {}
    return @cache[key] if @cache[key]

    result = 0
    if ['.', '?'].include?(value[0])
      result += search(value[1..], numbers)
    end
    if ['#', '?'].include?(value[0]) && numbers[0] <= value.size && value[0..numbers[0] - 1].exclude?('.') && value[numbers[0]] != '#'
      result += search(value[numbers[0] + 1..], numbers[1..])
    end

    @cache[key] = result
  end

  def self.part1(part2 = false)
    arrangements = file.split("\n").map{|line| line.split(" ") }.map do |arrangement, numbers|
      [arrangement, numbers.numbers]
    end

    Parallel.map(arrangements) do |arrangement, numbers|
      if part2
        ac = arrangement.clone
        nc = numbers.clone

        4.times { arrangement += '?' + ac }
        4.times { numbers += nc }
      end

      search(arrangement, numbers)
    end.sum
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(7792)
  end

  it "does part 2" do
    expect(Day12.part2).to eq(13012052341533)
  end
end
