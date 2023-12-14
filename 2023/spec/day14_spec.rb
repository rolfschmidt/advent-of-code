class Day14 < Helper
  def self.part1(part2 = false)
    map       = file.to_2d
    movements = [top]
    movements = [top, left, bottom, right] if part2

    cache = {}
    total = 1
    total = 1000000000 if part2
    round = 0
    while round < total do
      round   += 1
      old_map  = ddup(map)

      movements.each do |to_base|
        loop do
          moving = false
          map.each_with_index do |y, yi|
            y.each_with_index do |x, xi|
              next if x != 'O'

              to = Vector.new(xi + to_base.x, yi + to_base.y)
              next if !map.pos?(x: to.x, y: to.y) || map[to.y][to.x] != '.'

              moving = true
              map[to.y][to.x], map[yi][xi] = map[yi][xi], map[to.y][to.x]
            end
          end

          break if !moving
        end
      end

      next if !part2

      key = [old_map, ddup(map)]
      if cache[key]
        step  = round - cache[key]
        left  = total - round
        round = total - (left % step)
        next
      end

      cache[key] = round
    end

    map.select_vec('O').sum{|v| map.size - v.y }
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day14" do
  it "does part 1" do
    expect(Day14.part1).to eq(108918)
  end

  it "does part 2" do # 100151 100149 100305
    expect(Day14.part2).to eq(100310)
  end
end
