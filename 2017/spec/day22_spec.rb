class Day22 < Helper
  def self.left
    @left ||= {
      Vector.new(0, 0) => Vector.new(-1, 0),
      Vector.new(-1, 0) => Vector.new(0, 1),
      Vector.new(0, 1) => Vector.new(1, 0),
      Vector.new(1, 0) => Vector.new(0, -1),
      Vector.new(0, -1) => Vector.new(-1, 0),
    }
  end

  def self.right
    @right ||= {
      Vector.new(0, 0) => Vector.new(1, 0),
      Vector.new(1, 0) => Vector.new(0, 1),
      Vector.new(0, 1) => Vector.new(-1, 0),
      Vector.new(-1, 0) => Vector.new(0, -1),
      Vector.new(0, -1) => Vector.new(1, 0),
    }
  end

  def self.input
    file.split("\n").map(&:chars)
  end

  def self.init_map 
    map = {}
    input.each_with_index do |yv, yi|
      yv.each_with_index do |xv, xi|
        next if xv != '#'

        map[Vector.new(xi, yi)] = true
      end
    end
    map
  end

  def self.part1
    map = init_map
    x = input.first.size / 2
    y = input.size / 2
    pos = Vector.new(x, y)
    dir = Vector.new(0, 0)
    count = 0
    10000.times do |r|
      state = map[pos]
      map[pos] = !state

      if state
        dir = right[dir]
        pos += dir
      else
        count += 1
        dir = left[dir]
        pos += dir
      end
    end

    count
  end

  def self.part2
    map = init_map

    map = map.map{|v| [v[0], 'infected'] }.to_h
    states = ['clean', 'weak', 'infected', 'flagged']

    x = input.first.size / 2
    y = input.size / 2
    pos = Vector.new(x, y)
    dir = Vector.new(0, 0)
    count = 0
    10000000.times do |r|
      state = map[pos] || 'clean'

      map[pos] = states[(states.index(state) + 1) % states.size]
      if state == 'clean'
        dir = left[dir]
        pos += dir
      elsif state == 'weak'
        count += 1
        pos += dir
      elsif state == 'infected'
        dir = right[dir]
        pos += dir
      elsif state == 'flagged'
        dir = right[dir]
        dir = right[dir]
        pos += dir
      end
    end

    count
  end
end

RSpec.describe "Day22" do
  it "does part 1" do
    expect(Day22.part1).to eq(5406)
  end

  it "does part 2" do
    expect(Day22.part2).to eq(2511640)
  end
end