class Day21 < Helper

=begin

pad 1

7 8 9
4 5 6
1 2 3
. 0 A

=end

  def self.pad1
    @pad1 ||= {
      Vector.new(0, 0) => '7',
      Vector.new(1, 0) => '8',
      Vector.new(2, 0) => '9',
      Vector.new(0, 1) => '4',
      Vector.new(1, 1) => '5',
      Vector.new(2, 1) => '6',
      Vector.new(0, 2) => '1',
      Vector.new(1, 2) => '2',
      Vector.new(2, 2) => '3',
      Vector.new(1, 3) => '0',
      Vector.new(2, 3) => 'A',
    }
  end

=begin

pad 2

. ^ A
< v >

=end

  def self.pad2
    @pad2 ||= {
      Vector.new(1, 0) => '^',
      Vector.new(2, 0) => 'A',
      Vector.new(0, 1) => '<',
      Vector.new(1, 1) => 'v',
      Vector.new(2, 1) => '>',
    }
  end

  def self.quick_paths(pad, from, to)
    cache(pad, from, to) do
      pad.manhattan_paths(from, to)
    end
  end

  def self.solve_key(pad, from:, to:)
    cache(pad, from, to) do
      cur_key    = from
      key        = to
      find_paths = quick_paths(pad, pad.key(cur_key), pad.key(key))
      result     = []

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

    result = 0
    codes.each do |code|
      shortest = solve_length(code, part2 ? 25 : 2)
      result += shortest * code.join.numbers.first
    end

    result
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