class Day16 < Helper
  def self.map
    @map ||= file.to_2d.to_map
  end

  def self.get_dirs(char, pos, dir)
    queue = []
    if char == '.'
      queue << [pos, dir]
    elsif char == '|' && (dir == left || dir == right)
      queue << [pos, top]
      queue << [pos, bottom]
    elsif char == '|' && (dir == top || dir == bottom)
      queue << [pos, dir]
    elsif char == '-' && (dir == left || dir == right)
      queue << [pos, dir]
    elsif char == '-' && (dir == top || dir == bottom)
      queue << [pos, left]
      queue << [pos, right]
    elsif char == '/' && dir == right
      queue << [pos, top]
    elsif char == '/' && dir == bottom
      queue << [pos, left]
    elsif char == '/' && dir == left
      queue << [pos, bottom]
    elsif char == '/' && dir == top
      queue << [pos, right]
    elsif char == '\\' && dir == right
      queue << [pos, bottom]
    elsif char == '\\' && dir == bottom
      queue << [pos, right]
    elsif char == '\\' && dir == left
      queue << [pos, top]
    elsif char == '\\' && dir == top
      queue << [pos, left]
    end
    return queue
  end

  def self.count(queue)
    seen = {}
    while queue.present?
      pos, dir = queue.shift

      key = [pos.clone, dir.clone]
      next if seen[key]
      seen[key] = true

      pos += dir
      next if !map[pos]

      queue += get_dirs(map[pos], pos, dir)
    end
    seen.keys.map{|v| v[0] }.uniq.count
  end

  def self.part1
    queue = get_dirs(map[Vector.new(0,0)], Vector.new(0,0), right)
    count(queue)
  end

  def self.part2
    minx = map.minx
    maxx = map.maxx
    miny = map.miny
    maxy = map.maxy

    total = []
    (minx..maxx).each do |xi|
      total << count(get_dirs(map[Vector.new(xi, 0)], Vector.new(xi, 0), right))
      total << count(get_dirs(map[Vector.new(xi, 0)], Vector.new(xi, 0), left))
      total << count(get_dirs(map[Vector.new(xi, maxy)], Vector.new(xi, 0), right))
      total << count(get_dirs(map[Vector.new(xi, maxy)], Vector.new(xi, 0), left))
    end
    (miny..maxy).each do |yi|
      total << count(get_dirs(map[Vector.new(0, yi)], Vector.new(0, yi), top))
      total << count(get_dirs(map[Vector.new(0, yi)], Vector.new(0, yi), bottom))
      total << count(get_dirs(map[Vector.new(maxx, yi)], Vector.new(maxx, yi), top))
      total << count(get_dirs(map[Vector.new(maxx, yi)], Vector.new(maxx, yi), bottom))
    end

    total.max
  end
end

RSpec.describe "Day16" do
  it "does part 1" do
    expect(Day16.part1).to eq(7242)
  end

  it "does part 2" do
    expect(Day16.part2).to eq(7572)
  end
end
