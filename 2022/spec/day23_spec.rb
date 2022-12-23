class Day23 < Helper
  def self.part1(part2 = false)
    grid = {}
    file.split("\n").map{|v| v.split("") }.each_with_index do |yv, y|
      yv.each_with_index do |xv, x|
        next if xv != "#"

        grid[Vector[x, y]] = true
      end
    end

    rules = [:north, :south, :west, :east]
    moved = false
    round = 0

    (part2 ? 1e5 : 10).to_i.times do
      round += 1
      moves = {}

      if round % 100 == 0
        puts "#{round} / 1079"
      end

      grid.each do |pos, _|
        north = grid[pos + Vector[-1, -1]] || grid[pos + Vector[0, -1]] || grid[pos + Vector[1, -1]]
        south = grid[pos + Vector[-1, 1]] || grid[pos + Vector[0, 1]] || grid[pos + Vector[1, 1]]
        west  = grid[pos + Vector[-1, -1]] || grid[pos + Vector[-1, 0]] || grid[pos + Vector[-1, 1]]
        east  = grid[pos + Vector[1, -1]] || grid[pos + Vector[1, 0]] || grid[pos + Vector[1, 1]]

        next if !north && !south && !west && !east

        rules.each do |rule|
          if !north && rule == :north
            moves[pos + Vector[0, -1]] ||= []
            moves[pos + Vector[0, -1]] << pos
          elsif !south && rule == :south
            moves[pos + Vector[0, 1]] ||= []
            moves[pos + Vector[0, 1]] << pos
          elsif !west && rule == :west
            moves[pos + Vector[-1, 0]] ||= []
            moves[pos + Vector[-1, 0]] << pos
          elsif !east && rule == :east
            moves[pos + Vector[1, 0]] ||= []
            moves[pos + Vector[1, 0]] << pos
          else
            next
          end
          break
        end
      end

      moves.each do |to, froms|
        next if moves[to].count > 1

        pos = froms.shift
        grid.delete(pos)
        grid[to] = true
      end

      rules << rules.shift

      break if moves.blank? && part2
    end

    minx = grid.map{|v, _| v[0] }.min
    maxx = grid.map{|v, _| v[0] }.max
    miny = grid.map{|v, _| v[1] }.min
    maxy = grid.map{|v, _| v[1] }.max

    free = {}
    counter = 0
    (miny..maxy).each do |y|
      (minx..maxx).each do |x|
        next if grid[Vector[x, y]]

        counter += 1
      end
    end

    return round if part2

    counter
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day23" do
  it "does part 1" do
    expect(Day23.part1).to eq(4241)
  end

  it "does part 2" do
    expect(Day23.part2).to eq(1079)
  end
end