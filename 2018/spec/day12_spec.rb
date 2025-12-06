class Day12 < Helper
  def self.generate
    @generate ||= begin
      state, commands = file.blocks
      map = state.split(': ')[1].to_map
      commands = commands.lines.map { _1.split(' => ') }

      result = {}
      diff = 0
      diff_times = 0
      200.times do |i|
        new_map = map.to_h { [_1, '.'] }

        (map.minx - 5..0).each do |px|
          map[Vector.new(px, 0)] ||= '.'
        end
        (map.maxx..map.maxx + 5).each do |px|
          map[Vector.new(px, 0)] ||= '.'
        end

        (map.minx..map.maxx).each do |px|
          pos = Vector.new(px, 0)

          commands.each do |from, to|
            l1 = map[pos + DIR_LEFT] || '.'
            l2 = map[pos + DIR_LEFT + DIR_LEFT] || '.'
            r1 = map[pos + DIR_RIGHT] || '.'
            r2 = map[pos + DIR_RIGHT + DIR_RIGHT] || '.'

            check = "#{l2}#{l1}#{map[pos]}#{r1}#{r2}"
            if from == check
              new_map[pos] = to
              break
            end
          end
        end

        map = new_map
        result[i + 1] = map.select_value('#').keys.map { _1.x }.sum

        new_diff = (result[i + 1] - (result[i] || 0))
        if diff != new_diff
          diff = new_diff
          diff_times = 1
        else
          diff_times += 1
        end

        break if diff_times == 3 && diff == new_diff
      end

      {
        rounds: result,
        diff: diff,
      }
    end
  end

  def self.part1
    generate[:rounds][20]
  end

  def self.part2
    rounds    = generate[:rounds]
    max_round = rounds.keys.max

    rounds[max_round] + (50000000000 - max_round) * generate[:diff]
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(1991)
  end

  it "does part 2" do
    expect(Day12.part2).to eq(1100000000511)
  end
end
