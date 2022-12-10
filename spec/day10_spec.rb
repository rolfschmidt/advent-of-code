class Day10 < Helper
  def self.calc(cycle)
    result  = 1
    data    = file.split("\n").map{|v| v.split(" ") }
    run_cmd = []

    i = 1
    while i < cycle do
      if run_cmd.present?
        result += run_cmd[1].to_i
        run_cmd = nil
      elsif data.present?
        add_cmd = data.shift

        if add_cmd[0] != 'noop'
          run_cmd = add_cmd
        end
      end

      i += 1
    end

    result
  end

  def self.part1
    [20, 60, 100, 140, 180, 220].map{|v| calc(v) * v }.sum
  end

  def self.part2
    matrix = ['.'] * 240

    240.times do |crt|
      pos = calc(crt + 1)
      next if [pos - 1, pos, pos + 1].exclude?(crt % 40)

      matrix[crt] = "#"
    end

    matrix.each_slice(40).map(&:join).join("\n")
  end
end

RSpec.describe "Day10" do
  it "does part 1" do
    expect(Day10.part1).to eq(17940)
  end

  it "does part 2" do
    expect(Day10.part2).to eq(<<-RESS
####..##..###...##....##.####...##.####.
...#.#..#.#..#.#..#....#.#.......#....#.
..#..#....###..#..#....#.###.....#...#..
.#...#....#..#.####....#.#.......#..#...
#....#..#.#..#.#..#.#..#.#....#..#.#....
####..##..###..#..#..##..#.....##..####.
RESS
.chomp)
  end
end