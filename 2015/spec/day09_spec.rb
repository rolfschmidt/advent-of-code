class Day09 < Helper
  def self.travel(to, seen: [])
    return [0] if seen.size == @map.keys.size

    result = []
    @map[to].each do |location|
      next if seen.include?(location[0])

      travel(location[0], seen: seen.clone + [ location[0] ]).each do |dist|
        result << location[1] + dist
      end
    end
    result
  end

  def self.part1(part2 = false)
    @map = {}
    file.split("\n").each do |line|
      from, _, to  = line.words
      @map[from] ||= []
      @map[to]   ||= []
      @map[from]  << [to, line.numbers[0]]
      @map[to]    << [from, line.numbers[0]]
    end

    @map.keys.map{|v| travel(v, seen: [v]) }.flatten.send(part2 ? :max : :min)
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day09" do
  it "does part 1" do
    expect(Day09.part1).to eq(141)
  end

  it "does part 2" do # 683
    expect(Day09.part2).to eq(736)
  end
end
