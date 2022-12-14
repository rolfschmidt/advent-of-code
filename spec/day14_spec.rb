Sand = Struct.new(:x, :y) do
  def fall(matrix, maxy, part2 = false)
    [
      [0, 1],
      [-1, 1],
      [1, 1],
    ].each do |dx, dy|
      posx = x + dx
      posy = y + dy
      pos  = matrix["#{posx}_#{posy}"]
      next if !pos.nil?

      return (part2 ? self : nil) if y > maxy

      self.x = posx
      self.y = posy

      return fall(matrix, maxy, part2)
    end

    return if x == 500 && y == 0
    return self
  end
end

Rock = Struct.new(:x, :y)

class Day14 < Helper
  def self.part1(part2 = false)
    matrix = {}
    from = nil
    file.split("\n").each do |line|
      line.split(" -> ").each do |part|
        rock = Rock.new(*part.split(",").map(&:to_i))

        from ||= rock
        ([from.y, rock.y].min..[from.y, rock.y].max).each do |y|
          ([from.x, rock.x].min..[from.x, rock.x].max).each do |x|
            rock_line = Rock.new(x, y)
            matrix[rock_line.to_s] = rock_line
          end
        end
        from = rock
      end
      from = nil
    end

    maxy = matrix.values.grep(Rock).map(&:y).max

    i = 0
    while true do
      sand = Sand.new(500, 0).fall(matrix, maxy, part2)
      break if sand.nil?

      matrix[sand.to_s] = sand
      i += 1
    end

    i
  end

  def self.part2
    part1(true) + 1
  end
end

RSpec.describe "Day14" do
  it "does part 1" do
    expect(Day14.part1).to eq(696)
  end

  it "does part 2" do
    expect(Day14.part2).to eq(23610)
  end
end