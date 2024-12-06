class Day06 < Helper
  def self.run(map, cur_pos, cur_dir, part2: false, search: false)
    blocker = {}
    path    = {}

    while true do
      return true if search && path["#{cur_pos}_#{cur_dir}"]
      path["#{cur_pos}_#{cur_dir}"] = true

      check = cur_pos + cur_dir
      break if map[check].nil?

      if map[check] == '#' || map[check] == 'O'
        cur_dir = @next_dirs[cur_dir]
        next
      end
      if part2
        temp_pos        = cur_pos.dup
        temp_dir        = @next_dirs[cur_dir].dup
        temp_map        = map.dup
        temp_map[check] = 'O'

        blocker[check] = run(temp_map, temp_pos, temp_dir, search: true) if blocker[check].nil?
      end

      map[check] = 'X'
      cur_pos = check
    end

    return false if search

    [map, blocker]
  end

  def self.part1(part2 = false)
    map = file.to_map

    @dirs = {
      '^' => DIR_UP,
      '>' => DIR_RIGHT,
      'v' => DIR_DOWN,
      '<' => DIR_LEFT,
    }
    @next_dirs = {
      DIR_UP => DIR_RIGHT,
      DIR_RIGHT => DIR_DOWN,
      DIR_DOWN => DIR_LEFT,
      DIR_LEFT => DIR_UP,
    }

    cur_pos, start_key = map.find{|k,v| v == '^' }
    cur_dir = @dirs[start_key]

    map, blocker = run(map, cur_pos, cur_dir, part2: part2)
    return blocker.values.count(true) if part2

    map.values.count { _1 == 'X' } + 1
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day06" do
  it "does part 1" do
    expect(Day06.part1).to eq(5531)
  end

  it "does part 2" do
    expect(Day06.part2).to eq(2165)
  end
end