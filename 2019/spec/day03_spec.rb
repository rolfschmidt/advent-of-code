class Day03 < Helper
  def self.part1
    lines     = file.lines.map { _1.split(/,/) }
    map       = {}
    min_steps = INT_MAX
    min_dist  = INT_MAX
    lines.each_with_index do |line, li|
      pos   = Vector.new(0, 0)
      steps = 0
      line.each do |string|
        dir = DIRS_ALPHA[string[0]]
        value = string[1..].to_i

        value.times do
          steps += 1
          pos += dir
          map[pos] ||= {}
          map[pos][li] = steps

          if map[pos].keys.size == 2
            min_dist  = [min_dist, pos.x.abs + pos.y.abs].min
            min_steps = [min_steps, map[pos].values.sum].min
          end
        end

      end
    end

    return min_dist if !part2?

    min_steps
  end

  def self.part2
    part1
  end
end

RSpec.describe "Day03" do
  it "does part 1" do
    expect(Day03.part1).to eq(207)
  end

  it "does part 2" do
    expect(Day03.part2).to eq(21196)
  end
end
