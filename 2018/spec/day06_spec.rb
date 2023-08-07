class Day06 < Helper
  def self.manhattan(pt1, pt2)
    (pt1[0]-pt2[0]).abs + (pt1[1]-pt2[1]).abs
  end

  def self.part1(part2 = false)
    coords = file.split("\n").map{|v| Vector.new(*v.split(', ').map(&:to_i)) }

    map = {}

    minx = coords.min_by{|v| v[0] }[0]
    maxx = coords.max_by{|v| v[0] }[0]
    miny = coords.min_by{|v| v[1] }[1]
    maxy = coords.max_by{|v| v[1] }[1]

    show = false
    (miny..maxy).each do |y|
      (minx..maxx).each do |x|
        pos = Vector.new(x, y)
        nearest = coords.map.with_index{|v, vi| [vi, v.manhattan(pos)] }.sort_by{|v| v[1] }

        if part2 && nearest.sum{|v| v[1] } >= 10000
          print "." if show
          next
        end

        if !part2 && nearest[0][1] == nearest[1][1]
          print "." if show
          next
        end

        if part2
          map[pos] = '#'
        else
          map[pos] = nearest[0][0]
        end

        print map[pos] if show
      end
      print "\n" if show
    end

    map.values.tally.values.max
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day06" do
  it "does part 1" do
    expect(Day06.part1).to eq(3620) # 7101
  end

  it "does part 2" do
    expect(Day06.part2).to eq(39930)
  end
end
