class Day18 < Helper
  def self.part1(part2 = false)
    directions = file.split("\n").each_with_object([]) do |line, result|
      ds = part2 ? line.words[2][5].to_i : line.words[0]
      d  = if ds == 'R' || ds == 0
            right
          elsif ds == 'L' || ds == 2
            left
          elsif ds == 'U' || ds == 3
            top
          elsif ds == 'D' || ds == 1
            bottom
          end

      if part2
        result << [d, line.words[2][0..4].hex]
      else
        result << [d, line.numbers[0]]
      end
    end

    start       = Vector.new(0, 1)
    edges       = [start]
    edge_length = 0
    current     = start
    directions.each do |d, t|
      current.x += d.x * t
      current.y += d.y * t
      edge_length += t
      edges << current.clone
    end

    # https://stackoverflow.com/a/4937281
    return ((edges.each_cons(2).sum {|a, b| (a.x * b.y) - (b.x * a.y) } + edge_length) * 0.5 + 1).to_i
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day18" do
  it "does part 1" do
    expect(Day18.part1).to eq(49897)
  end

  it "does part 2" do # 389541427683085 389567526354473
    expect(Day18.part2).to eq(194033958221830)
  end
end