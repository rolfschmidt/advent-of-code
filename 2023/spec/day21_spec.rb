class Day21 < Helper
  def self.map
    @map ||= file.to_2d.to_map
  end

  def self.part1(round_step = 64)
    start = map.find{|k, v| v == 'S' }[0]
    queue = [[start, round_step]]
    result = {}
    seen = {}
    while queue.present?
      pos, step, step_size = queue.shift

      if step <=0
        result[pos] = true
        next
      end

      [top, right, bottom, left].each do |dir|
        new_pos = pos + dir
        next if !map[new_pos]
        next if map[new_pos] == '#'
        next if seen[[new_pos, step]]
        seen[[new_pos, step]] = true

        queue << [new_pos, step - 1]
      end
    end

    # (map.miny..map.maxy).each do |yi|
    #   (map.minx..map.maxx).each do |xi|
    #     sp = Vector.new(xi, yi)
    #     if result[sp]
    #       print "O"
    #     else
    #       print map[sp]
    #     end
    #   end
    #   print "\n"
    # end

    return result.keys.count
  end

  def self.simplified_lagrange(values)
    return [
      values[0] / 2 - values[1] + values[2] / 2,
      -3 * (values[0] / 2) + 2 * values[1] - values[2] / 2,
      values[0],
    ]
  end

  # gave up on this
  # had a nice idea for warshall solution but couldnt even process the base grid
  # yoinked, props to https://www.reddit.com/r/adventofcode/comments/18nevo3/comment/keb6a53/
  def self.part2
    start = map.find{|k, v| v == 'S' }[0]

    queue       = [start]
    seen        = {}
    maxx        = map.maxx
    maxy        = map.maxy
    blocker     = map.keys.select{|key| map[key] == '#' }.to_set
    totals      = {}
    need_rounds = [65, 65 + 131, 65 + 131 * 2]
    (1..need_rounds.max).each do |round|
      new_queue = Set.new
      queue.each do |pos|
        [top, right, bottom, left].each do |dir|
          new_pos = pos + dir
          new_local = Vector.new((pos.x + dir.x) % (maxx + 1), (pos.y + dir.y) % (maxy + 1))
          next if blocker.include?(new_local)
          next if new_queue.include?(new_pos)
          next if seen.key?(new_pos)
          seen[new_pos] = true

          new_queue << new_pos
        end
      end

      total = seen.values.select{|v| v == true }.count
      totals[round] = total
      puts "total of round #{round} = #{total}" if round % 50 == 0

      queue = new_queue
      seen.each do |k, v|
        seen[k] = !v
      end
    end

    poly   = simplified_lagrange(need_rounds.map{|v| totals[v] })
    target = (26_501_365 - 65) / 131
    return poly[0] * target * target + poly[1] * target + poly[2]
  end
end

RSpec.describe "Day21" do
  it "does part 1" do
    expect(Day21.part1).to eq(3722)
  end

  it "does part 2" do
    expect(Day21.part2).to eq(614864614526014)
  end
end