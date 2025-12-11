class Day09 < Helper
  def self.part1
    map     = file.lines.map(&:numbers).map(&:to_vec)
    maxdist = map.combination(2).max_by do |pa, pb|
      pa.manhattan(pb)
    end

    maxdist.rectangle_area
  end

  def self.outside(p0, p1, e0, e1)
    [p0, p1].max <= [e0, e1].min || [p0, p1].min >= [e0, e1].max
  end

  # gave up, no math skills
  # yoinked, props to @Turilas, https://www.reddit.com/r/adventofcode/comments/1phywvn/comment/nt6f5fa
  def self.part2
    edges = file.lines.map(&:numbers).map(&:to_vec)
    pairs = edges.combination(2)
    lines = edges.each_cons(2)

    sorted_distances = pairs.map do |c0, c1|
      [
        [c0, c1].rectangle_area,
        c0,
        c1
      ]
    end.sort_by do |pos|
      -pos[0]
    end

    sorted_distances.each do |dist, c0, c1|
      match = lines.all? do |p0, p1|
        outside(p0.x, p1.x, c0.x, c1.x) || outside(p0.y, p1.y, c0.y, c1.y)
      end

      return dist if match
    end
  end
end

RSpec.describe "Day09" do
  it "does part 1" do
    expect(Day09.part1).to eq(4744899849) # 7139196435
  end

  it "does part 2" do
    expect(Day09.part2).to eq(1540192500) # 4605625856
  end
end
