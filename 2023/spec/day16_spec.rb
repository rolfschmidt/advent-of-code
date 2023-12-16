class Day16 < Helper
  def self.map
    @map ||= file.to_2d.to_map
  end

  def self.dirs(pos, dir)
    char  = map[pos]
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

      key = [pos, dir]
      next if seen[key]
      seen[key] = true

      pos += dir
      next if !map[pos]

      queue += dirs(pos, dir)
    end
    seen.keys.map{|v| v[0] }.uniq.count
  end

  def self.part1
    queue = dirs(Vector.new(0,0), right)
    count(queue)
  end

  def self.part2
    minx = map.minx
    maxx = map.maxx
    miny = map.miny
    maxy = map.maxy

    total = []
    (minx..maxx).each do |xi|
      total << count(dirs(Vector.new(xi, 0), bottom))
      total << count(dirs(Vector.new(xi, maxy), top))
    end
    (miny..maxy).each do |yi|
      total << count(dirs(Vector.new(0, yi), right))
      total << count(dirs(Vector.new(maxx, yi), left))
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
