class Day14 < Helper
  def self.part1(part2 = false)
    map       = file.to_2d
    movements = [ Vector.new(0, -1) ]
    if part2
      movements = [
        Vector.new(0, -1),
        Vector.new(-1, 0),
        Vector.new(0, 1),
        Vector.new(1, 0),
      ]
    end

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

      key = [old_map, ddup(map)]
      if part2
        if cache[key]
          step  = round - cache[key]
          left  = total - round
          round = total - (left % step)
          next
        end

        cache[key] = round
        # repeating = cache[key] && cache[key].size > 2 && cache[key].each_cons(2).map{|a, b| b - a }.uniq.count == 1
        # if repeating
        #   step  = cache[key][1] - cache[key][0]
        #   left  = total - round
        #   round = total - (left % step)
        #   next
        # end

        # cache[key] ||= []
        # cache[key] << round
      end
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
