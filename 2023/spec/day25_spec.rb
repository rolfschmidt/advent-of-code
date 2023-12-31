class Day25 < Helper
  def self.edges
    @edges ||= begin
      edges = []
      file.split("\n").map{|line| line.words }.each do |comps|
        comps[1..].each do |comp|
          edges << [comps.first, comp, 1]
          edges << [comp, comps.first, 1]
        end
      end
      edges
    end
  end

  def self.part1
    cut, best = Graph.minimum_cut(Graph.matrix(edges))
    total     = edges.map(&:first).uniq

    return best.count * (total.count - best.count)
  end
end

RSpec.describe "Day25" do
  it "does part 1" do
    expect(Day25.part1).to eq(551196)
  end
end