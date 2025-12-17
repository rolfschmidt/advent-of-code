class Day06 < Helper
  def self.graph
    @graph ||= begin
      result = {}
      file.lines.map { _1.split(')') }.each do |from, to|
        result[from] ||= []
        result[from] |= [to]
        result[to] ||= []
        result[to] |= [from]
      end
      result
    end
  end

  def self.part1
    total = 0
    graph.keys.each do |start|
      next if start == 'COM'

      result = Graph.new(graph).find_paths('COM', start)
      total += result.first.size - 1
    end
    total
  end

  def self.part2
    Graph.new(graph).shortest_path('YOU', 'SAN').path.size - 3
  end
end

RSpec.describe "Day06" do
  it "does part 1" do
    expect(Day06.part1).to eq(144909)
  end

  it "does part 2" do
    expect(Day06.part2).to eq(259)
  end
end
