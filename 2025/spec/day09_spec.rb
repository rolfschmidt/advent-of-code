class Day09 < Helper
  def self.part1
    map     = file.lines.map(&:numbers).map(&:to_vec)
    maxdist = map.combination(2).max_by do |pa, pb|
      pa.manhattan(pb)
    end

    maxdist.rectangle_area
  end

  def self.calculate_edge_points(polygon, steps)
    points = []

    polygon.each_with_index do |(x1, y1), i|
      x2, y2 = polygon[(i + 1) % polygon.size]

      (0..steps).each do |s|
        t = s.to_f / steps
        points << [
          x1 + (x2 - x1) * t,
          y1 + (y2 - y1) * t
        ]
      end
    end

    points
  end

  def self.part2
    coords = file.lines.map(&:numbers).map(&:to_vec)
    map    = coords.to_h('X')
    sides  = coords.poligon_sides
    sides_seen = sides.to_set

    combos       = coords.combination(2)
    combos_count = combos.size
    check = Set.new
    combos.each do |pa, pb|
      next if pa.x == pb.x
      next if pa.y == pb.y

      check << Vector.new(pa.x, pb.y)
      check << Vector.new(pb.x, pa.y)
    end

    pp ['check', check.size]
    polimap = sides.poligon_pos_list?(check)

    pp ['polimap', polimap.size]
    exit

    Parallel.map(combos) do |pa, pb|
      next if pa.x == pb.x
      next if pa.y == pb.y

      ca = Vector.new(pa.x, pb.y)
      cb = Vector.new(pb.x, pa.y)

      next if [ca, cb].any? do |pos|
        next false if sides_seen.include?(pos)
        next false if sides.poligon_pos?(pos)
        true
      end

      [pa, pb].rectangle_area
    end.compact.max
  end
end

# puts Day09.part1
puts Day09.part2
return

RSpec.describe "Day09" do
  it "does part 1" do
    expect(Day09.part1).to eq(4744899849) # 7139196435
  end

  it "does part 2" do
    expect(Day09.part2).to eq(1540192500) # 4605625856
  end
end
