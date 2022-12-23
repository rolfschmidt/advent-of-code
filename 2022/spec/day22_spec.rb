class Day22 < Helper
  def self.part1
    parts = file.split("\n\n")

    directions = parts[1].split(/\d+/).zip(parts[1].split(/[A-Z]/)).flatten
    directions.shift

    grid = parts[0].split("\n").map{|v| v.split("").map(&:presence) }

    cur_pos = nil
    grid[0].each_with_index do |x, xi|
      next if grid[0][xi] != '.'

      cur_pos = Vector[xi, 0]

      break
    end

    rotations = [
      Vector[1, 0],
      Vector[0, 1],
      Vector[-1, 0],
      Vector[0, -1],
    ]
    chars = {
      Vector[1, 0]  => '>',
      Vector[0, 1]  => 'v',
      Vector[-1, 0] => '<',
      Vector[0, -1] => '^',
    }
    facing = {
      Vector[1, 0]  => 0,
      Vector[0, 1]  => 1,
      Vector[-1, 0] => 2,
      Vector[0, -1] => 3,
    }

    cur_dir    = Vector[1, 0]
    last_valid = nil

    directions.each do |ds|
      step = Vector[0, 0]
      if ds == "R"
        cur_dir = rotations[ (rotations.find_index(cur_dir) + 1) % rotations.size ]
        step += cur_dir
      elsif ds == "L"
        cur_dir = rotations[ (rotations.find_index(cur_dir) - 1) % rotations.size ]
        step += cur_dir
      else
        ds.to_i.times do
          next_pos = Vector[(cur_pos[0] + cur_dir[0]) % grid.size, (cur_pos[1] + cur_dir[1]) % grid.size]
          if grid.dig(next_pos[1], next_pos[0]) == '#'
            cur_pos = last_valid
            break
          end

          if grid.dig(next_pos[1], next_pos[0]).nil?
            cur_pos = next_pos
            redo
          end

          cur_pos = next_pos
          last_valid = cur_pos

          grid[cur_pos[1]][cur_pos[0]] = chars[cur_dir]
        end
      end
    end

    [(cur_pos[0] + 1) * 4, (cur_pos[1] + 1) * 1000, facing[cur_dir]].sum
  end

=begin

           x = 0          50         100        150
      +--------|---------------+          +--------------+
y     |        |               |          |              |
=     |        |               v          v              |
0     |        |          +----------+----------+        |
      |        |          |          |          |        |
      |    +---|--------->|    0     |    1     |<--+    |
      |    |   |          |          |          |   |    |
      |    |   |          |          |          |   |    |
50    |    |   |          +----------+----------+   |    |
      |    |   |          |          |    ^         |    |
      |    |   |     +--->|   2      |    |         |    |
      |    |   |     |    |          |<---+         |    |
      |    |   |     v    |          |              |    |
100   |    |   +----------+----------+              |    |
      |    |   |          |          |              |    |
      |    +-->|   4      |   3      |<-------------+    |
      |        |          |          |                   |
      |        |          |          |                   |
150   |        +----------+----------+                   |
      |        |          |    ^                         |
      +------->|   5      |    |                         |
               |          |<---+                         |
               |          |                              |
               +----------+                              |
               |     ^                                   |
               |     |                                   |
               |     +-----------------------------------+

=end

  # fuck this part, gave up
  # props to https://github.com/hyper-neutrino/advent-of-code/blob/main/2022/day22p2.py
  def self.part2
    parts = file.split("\n\n")

    grid  = parts[0].split("\n").map{|v| v.split("").map(&:presence) }
    cur_y = 0
    cur_x = 0
    dir_y = 0
    dir_x = 1

    while grid[cur_y][cur_x] != "."
      cur_x += 1
    end

    parts[1].scan(/(\d+)([RL]?)/).each do |step, step_direction|
      step = step.to_i
      step.times do
        next_dir_y = dir_y
        next_dir_x = dir_x
        next_y     = cur_y + dir_y
        next_x     = cur_x + dir_x

        if next_y < 0 && 50 <= next_x && next_x < 100 && dir_y == -1
          dir_y, dir_x = 0, 1
          next_y, next_x = next_x + 100, 0
        elsif next_x < 0 && 150 <= next_y && next_y < 200 && dir_x == -1
          dir_y, dir_x = 1, 0
          next_y, next_x = 0, next_y - 100
        elsif next_y < 0 && 100 <= next_x && next_x < 150 && dir_y == -1
          next_y, next_x = 199, next_x - 100
        elsif next_y >= 200 && 0 <= next_x && next_x < 50 && dir_y == 1
          next_y, next_x = 0, next_x + 100
        elsif next_x >= 150 && 0 <= next_y && next_y < 50 && dir_x == 1
          dir_x = -1
          next_y, next_x = 149 - next_y, 99
        elsif next_x == 100 && 100 <= next_y && next_y < 150 && dir_x == 1
          dir_x = -1
          next_y, next_x = 149 - next_y, 149
        elsif next_y == 50 && 100 <= next_x && next_x < 150 && dir_y == 1
          dir_y, dir_x = 0, -1
          next_y, next_x = next_x - 50, 99
        elsif next_x == 100 && 50 <= next_y && next_y < 100 && dir_x == 1
          dir_y, dir_x = -1, 0
          next_y, next_x = 49, next_y + 50
        elsif next_y == 150 && 50 <= next_x && next_x < 100 && dir_y == 1
          dir_y, dir_x = 0, -1
          next_y, next_x = next_x + 100, 49
        elsif next_x == 50 && 150 <= next_y && next_y < 200 && dir_x == 1
          dir_y, dir_x = -1, 0
          next_y, next_x = 149, next_y - 100
        elsif next_y == 99 && 0 <= next_x && next_x < 50 && dir_y == -1
          dir_y, dir_x = 0, 1
          next_y, next_x = next_x + 50, 50
        elsif next_x == 49 && 50 <= next_y && next_y < 100 && dir_x == -1
          dir_y, dir_x = 1, 0
          next_y, next_x = 100, next_y - 50
        elsif next_x == 49 && 0 <= next_y && next_y < 50 && dir_x == -1
          dir_x = 1
          next_y, next_x = 149 - next_y, 0
        elsif next_x < 0 && 100 <= next_y && next_y < 150 && dir_x == -1
          dir_x = 1
          next_y, next_x = 149 - next_y, 50
        end

        if grid[next_y][next_x] == "#"
          dir_y = next_dir_y
          dir_x = next_dir_x
          break
        end

        cur_y = next_y
        cur_x = next_x
      end

      if step_direction == "R"
        dir_y, dir_x = dir_x, -dir_y
      elsif step_direction == "L"
        dir_y, dir_x = -dir_x, dir_y
      end
    end

    if dir_y == 0
      if dir_x == 1
        facing = 0
      else
        facing = 2
      end
    else
      if dir_y == 1
        facing = 1
      else
        facing = 3
      end
    end

    1000 * (cur_y + 1) + 4 * (cur_x + 1) + facing
  end
end

RSpec.describe "Day22" do
  it "does part 1" do
    expect(Day22.part1).to eq(162186)
  end

  it "does part 2" do
    expect(Day22.part2).to eq(55267)
  end
end