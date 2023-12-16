class Day13 < Helper
  def self.part1(part2 = false)
    counts = {}
    file.split("\n").each do |line|
      pa = line.words[0]
      change = line.numbers[0] * (line.words[2] == 'gain' ? 1 : -1)
      pb = line.words[-1]

      counts[pa] ||= {}
      counts[pa][pb] = change
    end

    if part2
      counts['me'] = {}
    end

    counts.keys.permutation(counts.keys.count).map do |combo|
      total = 0
      combo.each_with_index do |p, pi|
        li = combo[(pi - 1) % combo.size]
        ri = combo[(pi + 1) % combo.size]

        total += (counts[p][li] || 0) + (counts[p][ri] || 0)
      end
      total
    end.max
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day13" do
  it "does part 1" do
    expect(Day13.part1).to eq(709)
  end

  it "does part 2" do
    expect(Day13.part2).to eq(668)
  end
end