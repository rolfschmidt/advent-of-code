class Day23 < Helper
  def self.part1(part2 = false)
    prog = file.lines
    register = {
      'a' => (part2 ? 1 : 0),
      'b' => 0,
    }

    progi = 0
    while progi < prog.size do
      line  = prog[progi]
      words = line.words
      nums  = line.numbers

      cmd = words[0]
      target = words[1]
      value = nums.first

      if cmd == 'hlf'
        register[target] = register[target] / 2
      elsif cmd == 'tpl'
        register[target] = register[target] * 3
      elsif cmd == 'inc'
        register[target] = register[target] + 1
      elsif cmd == 'jmp'
        progi += value
        next
      elsif cmd == 'jie'
        if register[target] % 2 == 0
          progi += value
          next
        end
      elsif cmd == 'jio'
        if register[target] == 1
          progi += value
          next
        end
      end

      progi += 1
    end

    register['b']
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day23" do
  it "does part 1" do
    expect(Day23.part1).to eq(307)
  end

  it "does part 2" do
    expect(Day23.part2).to eq(160)
  end
end