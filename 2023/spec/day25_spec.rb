class Day25 < Helper
  def self.edges
    @edges ||= begin
      edges = []
      file.split("\n").map{|line| line.words }.each do |comps|
        comps[1..].each do |comp|
          edges << [comps.first, comp]
          edges << [comp, comps.first]
        end
      end
      edges = edges.map{|v| v << 1 }
    end
  end

  # https://en.wikipedia.org/wiki/Stoer%E2%80%93Wagner_algorithm
  def self.global_min_cut(mat)
    best = [Float::INFINITY, []]
    n = mat.length
    co = Array.new(n) { |i| [i] }

    (1...n).each do |ph|
      w = mat[0].dup
      s = t = 0

      (n - ph).times do
        w[t] = -Float::INFINITY
        s, t = t, w.index(w.max)
        (0...n).each { |i| w[i] += mat[t][i] }
      end

      current_value = [w[t] - mat[t][t], co[t]]
      best = [best, current_value].min_by { |a, b| [a, b ? b.size : 0] }
      co[s].concat(co[t])
      (0...n).each { |i| mat[s][i] += mat[t][i] }
      (0...n).each { |i| mat[i][s] = mat[s][i] }
      mat[0][t] = -Float::INFINITY
    end

    best
  end

  def self.part1
    graph     = Dijkstra::Trace.new(edges)
    cut, best = global_min_cut(graph.graph_matrix)
    total     = edges.map(&:first).uniq

    return best.count * (total.count - best.count)
  end
end

RSpec.describe "Day25" do
  it "does part 1" do
    expect(Day25.part1).to eq(551196)
  end
end