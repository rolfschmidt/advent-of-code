class Day18 < Helper
  def self.compare(a, b)
    equal_count    = 0
    diff_one_count = 0

    (0..2).each do |si|
      if a[si] == b[si]
        equal_count += 1
      elsif (a[si] - b[si]).abs == 1
        diff_one_count += 1
      end
    end

    return 2 if equal_count == 2 && diff_one_count == 1
    0
  end

  def self.cubes
    @cubes ||= begin
      file.split("\n").map do |line|
        line.split(",").map(&:to_i)
      end
    end
  end

  def self.part1
    count = 0
    cubes.combination(2).each do |a, b|
      count += compare(a, b)
    end

    (cubes.count * 6) - count
  end

  def self.minx
    @minx ||= cubes.map{|c| c[0] }.min - 1
  end

  def self.maxx
    @maxx ||= cubes.map{|c| c[0] }.max + 1
  end

  def self.miny
    @miny ||= cubes.map{|c| c[1] }.min - 1
  end

  def self.maxy
    @maxy ||= cubes.map{|c| c[1] }.max + 1
  end

  def self.minz
    @minz ||= cubes.map{|c| c[2] }.min - 1
  end

  def self.maxz
    @maxz ||= cubes.map{|c| c[2] }.max + 1
  end

  def self.flood(start)
    queue = [start]
    seen  = {}
    count = {}
    while queue.present?
      row              = queue.shift
      rcube            = row[0..2]
      rx, ry, rz, from = row

      seen[rcube] ||= {}
      next if seen[rcube][from]
      seen[rcube][from] = true

      next if (minx..maxx).exclude?(rx)
      next if (miny..maxy).exclude?(ry)
      next if (minz..maxz).exclude?(rz)

      if (cubes & [rcube]).present?
        count[rcube] ||= {}
        count[rcube][from] = true

        next
      end

      [
        [rx + 1, ry, rz],
        [rx - 1, ry, rz],
        [rx, ry + 1, rz],
        [rx, ry - 1, rz],
        [rx, ry, rz + 1],
        [rx, ry, rz - 1],
      ].each do |x, y, z|
        next if [x, y, z] == [2, 2, 5]

        queue << [x, y, z, rcube]
      end
    end

    # 2 cases:
    # -> input example is closed so we have to search the outside
    # -> prod input is open so it will be done automatically
    total = count.map{|k, v| v.keys.count }.sum
    return flood([minx, miny, minz]) if !seen[[minx, miny, minz]]

    { count: total, seen: seen }
  end

  def self.part2
    flood([2, 2, 5])[:count]
  end
end

RSpec.describe "Day18" do
  it "does part 1" do
    expect(Day18.part1).to eq(3522)
  end

  it "does part 2" do
    expect(Day18.part2).to eq(2074)
  end
end