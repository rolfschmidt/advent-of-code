class Day01 < Helper
  def self.part1(position: 50, total: 0)
    file.lines.each do |value|
      op_add    = value[0] == 'R' ? :+ : :-
      steps     = part2? ? value[1..].to_i : 1
      step_size = part2? ? 1 : value[1..].to_i

      steps.times do
        position = position.send(op_add, step_size) % 100

        if position == 0
          total += 1
        end
      end
    end

    total
  end

  def self.part2
    part1
  end
end

RSpec.describe "Day01" do
  it "does part 1" do
    expect(Day01.part1).to eq(1011)
  end

  it "does part 2" do # 13515 6011 6018
    expect(Day01.part2).to eq(5937)
  end
end
