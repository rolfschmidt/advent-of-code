class Day03 < Helper
  def self.part1(part2 = false)
    map = {
      '^' => Vector[0, -1],
      '>' => Vector[1, 0],
      'v' => Vector[0, 1],
      '<' => Vector[-1, 0],
    }

    counts = {
      Vector[0, 0] => 1,
    }
    move = [Vector[0, 0]]
    if part2
      move << Vector[0, 0]
      counts[ Vector[0, 0] ] += 1
    end
    file.chomp.chars.each_with_index do |d, di|
      move[di % move.size] += map[d]

      counts[move[di % move.size]] ||= 0
      counts[move[di % move.size]] += 1
    end

    counts.keys.count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day03" do
  it "does part 1" do
    expect(Day03.part1).to eq(2081)
  end

  it "does part 2" do # 494
    expect(Day03.part2).to eq(2341)
  end
end
