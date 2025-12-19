class Day11 < Helper
  def self.part1(map = {})
    code = file

    pos  = Vector.new(0, 0)
    dir  = DIR_UP
    machine = Machine.new(code, wait_on_input: true)
    loop do
      machine.set_input(map[pos] || 0)
      result = machine.compute
      break if machine.halted?

      if !part2?
        map[pos] = machine.output[-2]
      else
        map[pos] = machine.output[-2] == 1 ? '#' : '.'
      end

      if machine.output[-1] == 0
        dir = dir.rotate_left
      else
        dir = dir.rotate_right
      end

      pos += dir
    end

    return "\n" + map.to_2ds(fill_nil: true) if part2?

    map.keys.size
  end

  def self.part2
    part1({ Vector.new(0, 0) => '#' })
  end
end

RSpec.describe "Day11" do
  it "does part 1" do
    expect(Day11.part1).to eq(1681)
  end

  it "does part 2" do
    expect(Day11.part2).to eq('
.####..##..####..##..###..#..#..##..#..#...
.#....#..#....#.#..#.#..#.#.#..#..#.#.#....
.###..#......#..#....#..#.##...#....##.....
.#....#.##..#...#....###..#.#..#.##.#.#....
.#....#..#.#....#..#.#.#..#.#..#..#.#.#....
.####..###.####..##..#..#.#..#..###.#..#...
')
  end
end
