class Day21 < Helper
  def self.pad1
    # 7 8 9
    # 4 5 6
    # 1 2 3
    # # 0 A
    @pad1 ||= "789\n456\n123\n#0A".to_map
  end

  def self.pad2
    # # ^ A
    # < v >
    @pad2 ||= "#^A\n<v>".to_map
  end

  def self.solve_key(pad, from:, to:)
    cache(pad, from, to) do
      find_paths = pad.manhattan_paths(pad.key(from), pad.key(to))

      find_paths.each_with_object([]) do |shortest_path, result|
        new_path = []
        if shortest_path.size > 1
          new_path += shortest_path.dirs.map { DIRS_STRING_OPPOSITE[_1] }
        end

        new_path << 'A'
        result << new_path
      end
    end
  end

  def self.solve_length(value, rounds = 2, depth = 0)
    cache(value, rounds, depth) do
      length = 0
      pad    = depth == 0 ? pad1 : pad2
      value.each_with_index do |char, ci|
        key_last = ci == 0 ? 'A' : value[ci - 1]
        key_curr = value[ci]
        moves    = solve_key(pad, from: key_last, to: key_curr)

        if depth == rounds
          length += moves[0].size
        else
          length += moves.map { solve_length(_1, rounds, depth + 1) }.min
        end
      end
      length
    end
  end

  def self.part1(part2 = false)
    codes = file.lines.map(&:chars)

    codes.sum do |code|
      shortest = solve_length(code, part2 ? 25 : 2)
      shortest * code.join.numbers.first
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day21" do
  it "does part 1" do
    expect(Day21.part1).to eq(138764) # 151012
  end

  it "does part 2" do
    expect(Day21.part2).to eq(169137886514152)
  end
end