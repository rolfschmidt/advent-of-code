class Day10 < Helper
  def self.map
    @map ||= begin
     result = {}
     file.split("\n").map.with_index do |line, yi|
       line.chars.each_with_index do |x, xi|
         result[Vector.new(xi, yi)] = x
       end
     end
     result
    end
  end

  def self.start
    @start ||= begin
      map.find {|k, v| v == 'S'}[0]
    end
  end

  def self.dirs
    @dirs ||= begin
      dirs = {
        '|' => [ top, bottom ],
        '-' => [ right, left ],
        'L' => [ top, right ],
        'J' => [ top, left ],
        '7' => [ bottom, left ],
        'F' => [ right, bottom ],
        '.' => [],
        'S' => [],
        nil => [],
      }

      [top, right, bottom, left].each do |dir|
        dir_pos   = start + dir
        dir_value = map[dir_pos]
        next if dirs[dir_value].none?{|dir| dir_pos + dir == start }
        dirs['S'] << dir
      end
      dirs
    end
  end

  def self.top
    @top ||= Vector.new(0, -1)
  end

  def self.right
    @right ||= Vector.new(1, 0)
  end

  def self.bottom
    @bottom ||= Vector.new(0, 1)
  end

  def self.left
    @left ||= Vector.new(-1, 0)
  end

  def self.search(queue, search_map, search_dirs, seen = {})
    while queue.present?
      pos = queue.shift
      search_dirs[ search_map[pos] ].each do |dir|
        dir_pos = pos + dir

        search_dirs[ search_map[dir_pos] ].any? do |back_dir|
          back_dir_pos = dir_pos + back_dir
          next if back_dir_pos != pos
          next if seen[dir_pos]
          seen[dir_pos] = true

          queue << dir_pos
        end
      end
    end
    seen
  end

  def self.part1_seen
    @part1_seen ||= search([start], map, dirs)
  end

  def self.part1(part2 = false)
    (part1_seen.size + 1) / 2
  end

  # didnt get part2 to work
  # yoinked trick 17, props to https://github.com/AlbertVeli/AdventOfCode/blob/master/2023/10/day10.py
  def self.part2
    minx = 0
    maxx = map.keys.max_by{|k| k.x }.x
    miny = 0
    maxy = map.keys.max_by{|k| k.y }.y

    # create new map
    new_map = map.clone

    # replace S with pipe name
    start2pipe = dirs.find{|k, v| v == dirs['S'] }[0]
    raise 'not start found' if !start2pipe
    new_map[start] = start2pipe

    insiders = 0
    (miny..maxy).each do |yi|
      in_simulated_reality = false
      (minx..maxx).each do |xi|
        pos = Vector.new(xi, yi)

        # replace all locations which are no
        # in part1 result with dot
        if !part1_seen[pos] && new_map[pos] != '.'
          new_map[pos] = '.'
        end

        value = new_map[pos]

        # - flip simulated reality at |, J and L
        if value == '|' or value == 'J' or value == 'L'
          in_simulated_reality = !in_simulated_reality
        elsif value == '.' && in_simulated_reality
          insiders += 1
        end
      end
    end

    # (miny..maxy).each do |yi|
    #   (minx..maxx).each do |xi|
    #     print new_map[Vector[xi, yi]] || 'X'
    #   end
    #   print "\n"
    # end

    insiders
  end
end

RSpec.describe "Day10" do
  it "does part 1" do # 3422 8573 7942
    expect(Day10.part1).to eq(6842)
  end

  it "does part 2" do # 304
    expect(Day10.part2).to eq(393)
  end
end
