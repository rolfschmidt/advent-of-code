class Day25 < Helper
  def self.graph
    @graph ||= begin
      result = {}
      file.lines.map(&:words).each do |comps|
        comps[1..].each do |to|
          result[comps.first] ||= {}
          result[comps.first][to] = 1

          result[to] ||= {}
          result[to][comps.first] = 1
        end
      end
      result
    end
  end

  def self.part1
    cut, best = Graph.new(graph).minimum_cut
    total     = graph.keys

    return best.count * (total.count - best.count)
  end
end

RSpec.describe "Day25" do
  it "does part 1" do
    expect(Day25.part1).to eq(551196)
  end
end
