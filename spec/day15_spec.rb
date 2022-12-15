class Coord < Struct
  def manhattan(bx, by)
    (x - bx).abs + (y - by).abs
  end
end

Sensor   = Coord.new(:x, :y, :closest) do
  def to_beacon
    @to_beacon ||= manhattan(closest.x, closest.y)
  end
end
Beacon   = Coord.new(:x, :y)
NoBeacon = Coord.new(:x, :y)

class Day15 < Helper
  def self.part1(part2 = false)
    matrix  = {}
    sensors = []
    beacons = []
    file.split("\n").each do |line|
      nums                = line.scan(/-?\d+/).map(&:to_i)
      beacon              = Beacon.new(nums[2], nums[3])
      sensor              = Sensor.new(nums[0], nums[1], beacon)
      matrix[sensor.to_s] = sensor
      matrix[beacon.to_s] = beacon
      sensors << sensor
      beacons << beacon
    end

    test_file = sensors.first.to_s == "2_18"

    if !part2
      check_y = if test_file
        10
      else
        2000000
      end

      sensors.each_with_index do |sensor, i|
        puts "sensor #{i + 1}/#{sensors.count}"
        dist = sensor.manhattan(sensor.closest.x, sensor.closest.y)

        rangey = (check_y..check_y)
        if part2
          rangey = (0..check_y)
        end

        rangey.each do |y|
          rangex = (sensor.x - dist..sensor.x + dist)
          if part2
            rangex = (sensor.x - dist..[check_y, sensor.x + dist].min)
          end

          rangex.each do |x|
            no_beacon = NoBeacon.new(x, y)
            next if matrix[no_beacon.to_s]
            next if sensor.manhattan(no_beacon.x, no_beacon.y) > dist

            matrix[no_beacon.to_s] = no_beacon
          end
        end
      end

      return matrix.values.grep(NoBeacon).count
    else
      total_range = if test_file
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

            puts "x: #{x}, y: #{y}"
            pp (x * 4000000) + y
            return (x * 4000000) + y
          end
        end
      end
    end
  end

  def self.part2
    part1(true)
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