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

  # @lowest = {}

  # def self.code_variants(list, ci = 0, result = [], &block)
  #   @lowest[list.hash] ||= 9999999999
  #   if result.size > @lowest[list.hash]
  #     puts "too high #{result.size}"
  #     return
  #   end

  #   if ci == list.size
  #     @lowest[list.hash] = [result.size, @lowest[list.hash]].min
  #     return block.call(result)
  #   end

  #   list[ci].each_with_index do |value, vi|
  #     code_variants(list, ci + 1, result + value, &block)
  #   end
  # end

  def self.select_lowest(list)
    min_size = list.min_by(&:size).size
    list.select { _1.size <= min_size }
  end

  def self.quick_paths(pad, from, to)
    cache(pad, from, to) do
      stop_on = -> (map: , start: , path: , data: ) do
        start == to
      end

      skip_on = -> (map: , from: , pos: , dir: , path: , data: ) do
        false
      end

      find_paths = pad.find_paths(from, stop_on: stop_on, skip_on: skip_on)
      select_lowest(find_paths[:paths])
    end
  end

  def self.solve_new(code, pad, ci: 0, result: { -1 => [ [''].to_set ] })
    cur_key = ci == 0 ? 'A' : code[ci - 1]
    key     = code[ci]

    result[ci] = solve_move(pad, from: cur_key, to: key)

    if ci == code.size - 1
      lists = (0..code.size - 1).map { result[_1].to_a }

      return lists[0].product(*lists[1..-1]).map(&:flatten)
    end
    return solve_new(code, pad, ci: ci + 1, result: result)
  end

  def self.solve_move(pad, from:, to:)
    cache(pad, from, to) do
      cur_key = from
      key     = to

      find_paths = quick_paths(pad, pad.key(cur_key), pad.key(key))

      result = Set.new
      find_paths.each do |shortest_path|
        new_path = []
        if shortest_path.size > 1
          new_path += shortest_path.dirs.map { DIRS_STRING_OPPOSITE[_1] }
        end
        new_path << 'A'

        result << new_path
      end

      result
    end
  end

  def self.part1(part2 = false)
    codes = file.lines.map(&:chars)

    result = 0
    codes.each do |code|
      puts "---"
      puts code.join

      # list = solve_new(code, pad1)
      # pp list

      # puts "done #{list.size}"
      # (part2 ? 25 : 2).times do |round|
      #   puts "round #{round}"

      #   new_list = []
      #   code_variants(list) do |code_p1|
      #     puts new_list.size if new_list.size % 1000 == 0
      #     new_list += solve_new(code_p1, pad2)
      #   end
      #   list = new_list
      #   puts "done #{list.size}"
      # end

      # # exit

      # # pp list.map { _1.map(&:join) }.combination(4).to_a

      # # exit

      list = solve_new(code, pad1)
      (part2 ? 25 : 2).times do |round|
        puts "round #{round}"

        new_list = Set.new
        list.each_with_index do |code_p1, cpi|
          print "."
          new_list += solve_new(code_p1, pad2)
        end
        list = select_lowest(new_list)
        puts "done #{list.size}"
      end
      puts

      shortest = list.min_by(&:size).size

      pp [shortest, code.join.numbers.first]
      result += shortest * code.join.numbers.first
    end

    result
  end

  def self.part2
    part1(true)
  end
end

puts Day21.part1
# puts Day21.part2
return

RSpec.describe "Day21" do
  it "does part 1" do
    expect(Day21.part1).to eq(138764) # 151012
  end

  it "does part 2" do
    expect(Day21.part2).to eq(100)
  end
end