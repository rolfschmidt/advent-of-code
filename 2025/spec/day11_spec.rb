class Day11 < Helper
  def self.graph
    @graph ||= file.lines.map(&:words).map { [_1[0], _1[1..]] }.to_h
  end

  def self.part1
    Graph.new(graph).count_paths('you', 'out')
  end

  def self.part2
    Graph.new(graph).count_paths_with('svr', 'out', ['fft', 'dac'])
  end
end

RSpec.describe "Day11" do
  it "does part 1" do
    expect(Day11.part1).to eq(431)
  end

  it "does part 2" do
    expect(Day11.part2).to eq(358458157650450) # 72975 104250 145950
  end
end
