class Coord < Struct
  def manhattan(bx, by)
    (x - bx).abs + (y - by).abs
  end
end

Sensor = Coord.new(:x, :y, :closest) do
  def to_beacon
    @to_beacon ||= manhattan(closest.x, closest.y)
  end
end

Beacon = Coord.new(:x, :y)

class Day15 < Helper
  def self.parse
    sensors = []
    beacons = []
    file.split("\n").each do |line|
      nums                = line.scan(/-?\d+/).map(&:to_i)
      beacon              = Beacon.new(nums[2], nums[3])
      sensor              = Sensor.new(nums[0], nums[1], beacon)
      sensors << sensor
      beacons << beacon
    end

    [sensors, beacons]
  end

  def self.test_file?
    sensors, beacons = parse
    sensors.first.to_s == "2_18"
  end

  def self.part1(part2 = false)
    sensors, beacons = parse

    y = if test_file?
      10
    else
      2000000
    end

    minx = sensors.map{|s| s.x - s.to_beacon }.min
    maxx = sensors.map{|s| s.x + s.to_beacon }.max

    count = 0
    (minx..maxx).each do |x|
      next if sensors.none?{|s| s.manhattan(x, y) <= s.to_beacon }
      next if beacons.any?{|b| b.x == x && b.y == y }

      count += 1
    end

    return count
  end

  def self.part2
    sensors, beacons = parse

    total_range = if test_file?
                    (0..20)
                  else
                    (0..4000000)
                  end

    sensors.each do |sensor|
      (0..sensor.to_beacon + 2).each do |dx|
        dy = (sensor.to_beacon + 1) - dx

        [[-1,-1],[-1,1],[1,-1],[1,1]].each do |signx, signy|
          x = sensor.x + (dx * signx)
          y = sensor.y + (dy * signy)
          next if total_range.exclude?(x) || total_range.exclude?(y)
          next if sensors.any?{|s| s.manhattan(x, y) <= s.to_beacon }

          return (x * 4000000) + y
        end
      end
    end
  end
end

RSpec.describe "Day15" do
  it "does part 1" do
    expect(Day15.part1).to eq(4424278)
  end

  it "does part 2" do
    expect(Day15.part2).to eq(10382630753392)
  end
end