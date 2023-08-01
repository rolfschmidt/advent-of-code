class Day19 < Helper
  def self.part1(part2 = false)
    map = file.split("\n").map{|v| v.split('') }

    x  = map.first.index('|')
    y  = 0
    dx = 0 
    dy = 1
    lx = 0
    ly = 0
    steps = 0
    result = ''
    loop do
      lx = x
      ly = y
      x += dx
      y += dy
      steps += 1

      break if !map[y][x]
      break if map[y][x] == ' '

      if map[y][x] =~ /[A-Z]/
        result += map[y][x]
      elsif map[y][x] == '+'
        [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1],
        ].each do |mx, my|
          next if y + my < 0
          next if x + mx < 0
          next if lx == x + mx && ly == y + my
          next if map.dig(y + my, x + mx).blank?
          next if map.dig(y + my, x + mx) == ' '

          dx = mx
          dy = my
        end
      end
    end

    return steps if part2

    result
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day19" do
  it "does part 1" do
    expect(Day19.part1).to eq('SXWAIBUZY')
  end

  it "does part 2" do
    expect(Day19.part2).to eq(16676)
  end
end