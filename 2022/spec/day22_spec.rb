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

  def self.part2
    100
  end
end

RSpec.describe "Day22" do
  it "does part 1" do
    expect(Day22.part1).to eq(162186)
  end

  it "does part 2" do
    expect(Day22.part2).to eq(100)
  end
end