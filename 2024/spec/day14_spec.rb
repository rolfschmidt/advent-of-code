class Day14 < Helper
  def self.part1(part2 = false)
    map   = {}
    input = file
    input.lines.map(&:numbers).each do |robot|
      x, y, vx, vy = robot

      map[Vector.new(x, y)] ||= []
      map[Vector.new(x, y)] << { step: Vector.new(vx, vy) }
    end

    stepx = input == file_test ? 11 : 101
    stepy = input == file_test ? 7 : 103

    (part2 ? 1000000000 : 100).times do |rounds|
      duplicates = false

      new_map = {}
      map.each do |pos, robots|
        robots.each do |robot|
          new_map[Vector.new((pos.x + robot[:step].x) % stepx, (pos.y + robot[:step].y) % stepy)] ||= []
          new_map[Vector.new((pos.x + robot[:step].x) % stepx, (pos.y + robot[:step].y) % stepy)] << robot

          duplicates = true if new_map[Vector.new((pos.x + robot[:step].x) % stepx, (pos.y + robot[:step].y) % stepy)].count > 1
        end
      end

      map = new_map

      return rounds + 1 if !duplicates && part2
    end

    counts = {}
    (0..(stepy - 1)).each do |cy|
      (0..(stepx - 1)).each do |cx|
        next if map[Vector.new(cx, cy)].blank?

        if cy < ((stepy - 1) / 2) && cx < ((stepx - 1) / 2)
          counts[:top_left] ||= 0
          counts[:top_left] += map[Vector.new(cx, cy)].count
        elsif cy < ((stepy - 1) / 2) && cx > ((stepx - 1) / 2)
          counts[:top_right] ||= 0
          counts[:top_right] += map[Vector.new(cx, cy)].count
        elsif cy > ((stepy - 1) / 2) && cx < ((stepx - 1) / 2)
          counts[:bottom_left] ||= 0
          counts[:bottom_left] += map[Vector.new(cx, cy)].count
        elsif cy > ((stepy - 1) / 2) && cx > ((stepx - 1) / 2)
          counts[:bottom_right] ||= 0
          counts[:bottom_right] += map[Vector.new(cx, cy)].count
        end
      end
    end

    counts.values.inject(:*)
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day14" do
  it "does part 1" do
    expect(Day14.part1).to eq(228690000)
  end

  it "does part 2" do
    expect(Day14.part2).to eq(7093)
  end
end