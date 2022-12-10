class Day10 < Helper
  def self.calc(cycle = 5, part2 = false)
    result  = 1
    data    = file.split("\n")
    run_cmd = []

    i = 1
    while i < cycle do
      if run_cmd.present?
        cmd, count = run_cmd

        result += count
        run_cmd = nil
      elsif data.present?
        add_cmd = data.shift.split(" ")
        add_cmd[1] = add_cmd[1].to_i

        if add_cmd[0] != 'noop'
          run_cmd = add_cmd
        end
      end

      i += 1
    end

    return result if part2

    result * cycle
  end

  def self.part1
    return calc(20) + calc(60) + calc(100) + calc(140) + calc(180) + calc(220)
  end

  def self.part2
    matrix = ['.'] * 240

    240.times do |crt|
      pos  = calc(crt + 1, true)
      crtm = crt % 40

      next if [pos - 1, pos, pos + 1].exclude?(crtm)

      matrix[crt] = "#"
    end

    result = ''
    matrix.each_slice(40) do |yv|
      yv.each do |xv|
        result += xv
      end

      result += "\n"
    end

    result
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
    )
  end
end