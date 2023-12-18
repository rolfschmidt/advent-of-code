class Day18 < Helper
  def self.part1(part2 = false)
    directions = file.split("\n").each_with_object([]) do |line, result|
      dir_name = part2 ? line.words[2][5].to_i : line.words[0]
      dir  = if dir_name == 'R' || dir_name == 0
            right
          elsif dir_name == 'L' || dir_name == 2
            left
          elsif dir_name == 'U' || dir_name == 3
            top
          elsif dir_name == 'D' || dir_name == 1
            bottom
          end

      if part2
        result << [dir, line.words[2][0..4].hex]
      else
        result << [dir, line.numbers[0]]
      end
    end

    current     = Vector.new(0, 1)
    edges       = [current.clone]
    edge_length = 0
    directions.each do |d, t|
      current.x += d.x * t
      current.y += d.y * t
      edge_length += t
      edges << current.clone
    end

    # https://stackoverflow.com/a/4937281
    # https://en.wikipedia.org/wiki/Shoelace_formula
    shoelace = edges.each_cons(2).sum {|a, b| (a.x * b.y) - (b.x * a.y) } / 2

    # https://en.wikipedia.org/wiki/Pick%27s_theorem
    return (shoelace + (edge_length / 2) + 1).to_i
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