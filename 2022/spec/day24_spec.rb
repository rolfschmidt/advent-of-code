class Day24 < Helper
  def self.minx
    1
  end

  def self.maxx
    @maxx ||= @grid[0].size - 2
  end

  def self.miny
    @miny ||= 1
  end

  def self.maxy
    @maxy ||= @grid.size - 2
  end

  def self.storm_move(storm)
    pos, dir, name = storm

    new_pos = Vector[
      minx + (pos[0] - minx + dir[0]) % maxx,
      miny + (pos[1] - miny + dir[1]) % maxy
    ]

    [new_pos, dir, name]
  end

  def self.move_snow(start, stop, storm_index)
    queue   = [[start, 0, storm_index]]

    @move_snow ||= {}
    cache_key    = queue.clone
    return @move_snow[cache_key] if @move_snow[cache_key]

    seen    = {}
    result  = []
    while queue.present?
      pos, time, storm_index = queue.shift

      if pos == stop
        result = [time, pos, storm_index]
        break
      end

      storm_index += 1
      storms       = @storms_time[storm_index % @storms_time.count]

      next if !seen.dig(storm_index, pos).nil? && seen.dig(storm_index, pos) <= time
      seen[storm_index]      ||= {}
      seen[storm_index][pos] ||= time

      [
        Vector[1, 0],
        Vector[-1, 0],
        Vector[0, 1],
        Vector[0, -1],
        Vector[0, 0],
      ].each do |dir|
        next_pos = pos + dir
        next if next_pos[1] < miny - 1
        next if next_pos[1] > maxy + 1
        next if next_pos[0] > maxx
        next if next_pos[0] < minx
        next if @walls[next_pos]
        next if storms[next_pos]

        queue << [next_pos, time + 1, storm_index]
      end
    end

    @move_snow[cache_key] = result

    result
  end

  def self.part1(part2 = false)
    @grid = file.to_2d

    @walls  = {}
    storms = []
    start  = nil
    stop   = nil

    @grid.each_with_index do |yv, y|
      yv.each_with_index do |xv, x|
        if xv == '#'
          @walls[Vector[x, y]] = true
        elsif y == 0 && xv == '.'
          start = Vector[x, 0]
        elsif y == @grid.count - 1 && xv == '.'
          stop = Vector[x, @grid.count - 1]
        elsif ['>', '<', '^', 'v'].include?(xv)
          if xv == '>'
            storms << [Vector[x, y], Vector[1, 0], '>']
          elsif xv == '<'
            storms << [Vector[x, y], Vector[-1, 0], '<']
          elsif xv == '^'
            storms << [Vector[x, y], Vector[0, -1], '^']
          elsif xv == 'v'
            storms << [Vector[x, y], Vector[0, 1], 'v']
          end
        end
      end
    end

    @storms_time = [storms.clone]
    while true do
      storms = storms.map{|st| storm_move(st) }
      break if @storms_time.include?(storms)
      @storms_time << storms.clone
    end
    @storms_time = @storms_time.map{|sts| sts.map{|v| [v[0], true] }.to_h }

    if part2
      to_goal   = move_snow(start, stop, 0)
      to_start  = move_snow(stop, start, to_goal[2])
      back_goal = move_snow(start, stop, to_start[2])

      return to_goal[0] + to_start[0] + back_goal[0]
    end

    move_snow(start, stop, 0)[0]
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day24" do
  it "does part 1" do
    expect(Day24.part1).to eq(264)
  end

  it "does part 2" do
    expect(Day24.part2).to eq(789)
  end
end
