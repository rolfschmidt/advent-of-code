Sand = Struct.new(:x, :y) do
  def to_s
    "#{x}_#{y}"
  end

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

Rock = Struct.new(:x, :y) do
  def to_s
    "#{x}_#{y}"
  end
end

class Day14 < Helper
  def self.maxx(matrix)
    matrix.values.select{|o| o.is_a?(Rock) }.map{|v| v.x }.max
  end

  def self.maxy(matrix)
    matrix.values.select{|o| o.is_a?(Rock) }.map{|v| v.y }.max
  end

  def self.minx(matrix)
    matrix.values.select{|o| o.is_a?(Rock) }.map{|v| v.x }.min
  end

  def self.miny(matrix)
    matrix.values.select{|o| o.is_a?(Rock) }.map{|v| v.y }.min
  end

  def self.part1(part2 = false)
    matrix = {}
    from = nil
    file.split("\n").each do |line|
      line.split(" -> ").each do |part|
        rock = Rock.new(*part.split(",").map(&:to_i))
        matrix[rock.to_s] = rock

        if from.nil?
          from = rock
        else
          ([from.y, rock.y].min..[from.y, rock.y].max).each do |y|
            ([from.x, rock.x].min..[from.x, rock.x].max).each do |x|
              rock_line = Rock.new(x, y)
              matrix[rock_line.to_s] = rock_line
            end
          end
          from = rock
        end
      end
      from = nil
    end

    i = 0
    while true do
      sand = Sand.new(500, 0)
      sand = sand.fall(matrix, maxy(matrix), part2)
      break if sand.nil?

      matrix[sand.to_s] = sand
      i += 1
    end

    if false
      (miny(matrix) - 10..maxy(matrix) + 10).each do |y|
        (minx(matrix) - 10..maxx(matrix) + 10).each do |x|
          o = matrix["#{x}_#{y}"]

          if o.present?
            if o.is_a?(Rock)
              print "#"
            else
              print "o"
            end
          else
            print "."
          end
        end
        print "\n"
      end
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