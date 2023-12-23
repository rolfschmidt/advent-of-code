class Day23 < Helper
  def self.part1
    map = file.to_2d.to_map

    start = Vector.new(0, 1)
    stop = Vector.new(map.maxx - 1, map.maxy)

    slopes = {
      '>' => right,
      '<' => left,
      '^' => top,
      'v' => bottom,
    }

    queue = Heap.new{|a, b| a[1].keys.count > b[1].keys.count }
    queue << [start, {}]
    longest = 0
    while queue.present?
      pos, path = queue.pop

      next if path[pos]
      path[pos] = true

      if pos == stop
        # (0..map.maxy).each do |y|
        #   (0..map.maxx).each do |x|
        #     sp = Vector.new(x, y)
        #     if path[sp]
        #       print "O"
        #     else
        #       print map[sp]
        #     end
        #   end
        #   print "\n"
        # end
        # pp longest
        longest = [longest, path.count].max
      end

      directions = [top, right, bottom, left]
      if slopes[map[pos]]
        directions = [slopes[map[pos]]]
      end

      directions.each do |dir|
        new_pos = pos + dir
        next if !map[new_pos]
        next if map[new_pos] == '#'
        next if path[new_pos]
        next if slopes[map[new_pos]] && slopes[map[new_pos]] != dir

        queue << [new_pos, path.clone]
      end
    end

    return longest - 1
  end

  def self.map
    @map ||= file.to_2d.to_map
  end

  def self.start
    @start ||= Vector.new(1, 0)
  end

  def self.stop
    @stop ||= Vector.new(map.maxx - 1, map.maxy)
  end

  def self.is_crossroad?(pos)
    [top, right, bottom, left].select{|d| map[pos + d] && ['#', '.'].exclude?(map[pos + d]) }.count >= 3
  end

  def self.find_next_crossroad(from)
    queue = []
    queue << [from, []]
    path = {}
    ways = []
    while queue.present?
      pos, way = queue.pop

      next if path[pos]
      path[pos] = true
      way << pos

      if (is_crossroad?(pos) || pos == start || pos == stop) && pos != from
        ways << way
        next
      end

      directions = [top, right, bottom, left].select{|d| map[pos + d] && map[pos + d] != '#' }.each do |dir|
        new_pos = pos + dir
        next if path[new_pos]

        queue << [new_pos, way.clone]
      end
    end

    return ways
  end

  def self.part2
    crossroads = {}
    map.keys.each do |pos|
      next if !is_crossroad?(pos)

      crossroads[pos] = true
    end

    crossroad_ways = {}
    crossroads.keys.each do |pos|
      ways = find_next_crossroad(pos)
      crossroad_ways[pos] ||= {}
      ways.each do |way|
        crossroad_ways[pos][way.last] = way.count
      end
    end

    start_cr = crossroad_ways.keys.find{|cr| crossroad_ways[cr][start] }
    queue    = [ [start_cr, crossroad_ways[start_cr][start] - 1, {}] ]

    totals = []
    counter = 0
    while queue.present?
      pos, count, seen = queue.shift

      counter += 1
      if counter % 1000000 == 0
        puts "#{counter} / #{totals.max}"
      end

      next if seen[pos]
      seen[pos] = true

      if crossroad_ways[pos] && crossroad_ways[pos][stop]
        final = count + crossroad_ways[pos][stop] - 1
        totals << final
        next
      end

      crossroad_ways[pos] ||= {}
      crossroad_ways[pos].keys.each do |cr|
        next if seen[cr]

        new_count = count + crossroad_ways[pos][cr] - 1
        queue << [cr, new_count, seen.clone]
      end
    end

    return totals.max
  end
end

RSpec.describe "Day23" do
  it "does part 1" do
    expect(Day23.part1).to eq(2130)
  end

  it "does part 2" do # 4391
    expect(Day23.part2).to eq(6710)
  end
end