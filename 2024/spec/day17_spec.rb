class Day17 < Helper
  def self.parse_input(input)
    data = input.blocks.map(&:lines).flatten.map(&:numbers).flatten

    [data.shift, data.shift, data.shift, data, data.join(',')]
  end

  def self.calc_state(opcode, literal_operand, progi, rega, regb, regc)
    result = nil

    combo_map = {
      0 => literal_operand,
      1 => literal_operand,
      2 => literal_operand,
      3 => literal_operand,
      4 => rega,
      5 => regb,
      6 => regc,
    }
    combo_operand = combo_map[literal_operand] || literal_operand

    if opcode == 0 # ADV
      rega /= 2 ** combo_operand
    elsif opcode == 1 # BXL
      regb = regb ^ literal_operand
    elsif opcode == 2 # BST
      regb = combo_operand % 8
    elsif opcode == 3 # JNZ
      return [literal_operand, rega, regb, regc, result] if rega != 0
    elsif opcode == 4 # BXC
      regb = regb ^ regc
    elsif opcode == 5 # OUT
      result = combo_operand % 8
    elsif opcode == 6 # BDV
      regb = rega / (2 ** combo_operand)
    elsif opcode == 7 # CDV
      regc = rega / (2 ** combo_operand)
    else
      raise 'calc fail'
    end

    [progi + 2, rega, regb, regc, result]
  end

  def self.calc_prog(rega, regb, regc, prog)
    result = []

    progi = 0
    while progi < prog.size
      opcode          = prog[progi]
      literal_operand = prog[progi + 1]

      progi, rega, regb, regc, result_add = calc_state(opcode, literal_operand, progi, rega, regb, regc)
      if result_add
        result << result_add
      end
    end

    result
  end

  def self.part1
    rega, regb, regc, prog, prog_string = parse_input(file)
    calc_prog(rega, regb, regc, prog).join(',')
  end

  # gave up, props to https://github.com/ypisetsky/advent-of-code/blob/main/yr2024/day17.py
  def self.get_best_quine_input(program, cursor, sofar)
    (0...8).each do |candidate|
      if calc_prog(sofar * 8 + candidate, 0, 0, program) == program[cursor..-1]
        return sofar * 8 + candidate if cursor.zero?

        ret = get_best_quine_input(program, cursor - 1, sofar * 8 + candidate)
        return ret unless ret.nil?
      end
    end
    nil
  end

  def self.part2
    rega, regb, regc, prog, prog_string = parse_input(file)
    get_best_quine_input(prog, prog.size - 1, 0)
  end
end

RSpec.describe "Day17" do
  it "does part 1" do
    expect(Day17.part1).to eq('1,0,2,0,5,7,2,1,3')
  end

  it "does part 2" do
    expect(Day17.part2).to eq(265652340990875)
  end
end
