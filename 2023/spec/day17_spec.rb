class Day17 < Helper
  def self.map
    @map ||= file.to_2d.to_map.to_flags{|k, v| [k, v.to_i] }
  end

  def self.start
    @start ||= Vector.new(0, 0)
  end

  def self.stop
    @stop ||= Vector.new(map.maxx, map.maxy)
  end

  def self.part1(part2 = false)
    queue = Heap.new{|a, b| a[3] < b[3] }
    queue << [start, nil, 0, 0]
    seen = {}
    best = nil
    while !best
      pos, dir, step, heat_loss = queue.pop

      if pos == stop && (!part2 || part2 && step >= 4)
        best = heat_loss
        break
      end

      key = [pos, dir, step]
      next if seen[key]
      seen[key] = true

      if dir && map[pos + dir] && ((!part2 && step < 3) || (part2 && step < 10))
        new_pos       = pos + dir
        new_heat_loss = heat_loss + map[new_pos]
        queue << [new_pos, dir, step + 1, new_heat_loss]
      end

      if !part2 || (part2 && (step >= 4 || dir.nil?))
        [top, right, bottom, left].each do |new_dir|
          next if !map[pos + new_dir]
          next if dir && new_dir == Vector.new(-dir.x, -dir.y)
          next if new_dir == dir

          new_pos  = pos + new_dir
          new_heat_loss = heat_loss + map[new_pos]

          queue << [new_pos, new_dir, 1, new_heat_loss]
        end
      end
    end

    best
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day17" do
  it "does part 1" do
    expect(Day17.part1).to eq(1013)
  end

  it "does part 2" do
    expect(Day17.part2).to eq(1215)
  end
end