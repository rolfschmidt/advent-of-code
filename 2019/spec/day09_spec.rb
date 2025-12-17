class Machine
  attr_accessor :parts, :run_index, :output, :relative_base

  def initialize(parts)
    @parts         = parts.is_a?(String) ? parts.split(/,/).map(&:to_i) : parts
    @output        = []
    @relative_base = 0
  end

  def op(op_index)
    parts[op_index] % 100
  end

  def mode(op_index, value_index)
    return 1 if parts[op_index] == 3
    return 0 if parts[op_index] <= 10

    data = parts[op_index].to_s.chars.reverse.map(&:to_i)
    data.shift
    data.shift

    target_index = value_index - (op_index + 1)

    return data[target_index] || 0
  end

  def mode_index(mode, value_index)
    result = nil
    if mode == 0 # position mode
      result = parts[value_index]
    elsif mode == 1 # immediate mode
      result = value_index
    elsif mode == 2 # relative mode
      result = relative_base + parts[value_index]
    else
      raise "invalid mode '#{mode}'!"
    end

    @parts << 0 while result > parts.size - 1

    result
  end

  def value(op_index, value_index)
    mode     = mode(op_index, value_index)
    to_index = mode_index(mode, value_index)

    parts[to_index]
  end

  def set_value(op_index, value_index, value)
    mode     = mode(op_index, value_index)
    to_index = mode_index(mode, value_index)

    @parts[to_index] = value

    1
  end

  def compute(input: 1, init_index: nil, all: false)
    @run_index  = init_index || 0
    input       = Array.wrap(input)
    input_index = init_index != 0 ? input.size - 1 : 0

    while true do
      operator = op(run_index)
      break if operator == 99

      result = nil
      if operator == 1 # add
        result = value(run_index, run_index + 1) + value(run_index, run_index + 2)
        set_value(run_index, run_index + 3, result)
        @run_index += 4
      elsif operator == 2 # mul
        result = value(run_index, run_index + 1) * value(run_index, run_index + 2)
        set_value(run_index, run_index + 3, result)
        @run_index += 4
      elsif operator == 3 # move
        addr = mode_index(mode(run_index, run_index + 1), run_index + 1)
        @parts[addr] = input[input_index] || input[0]
        input_index += 1
        @run_index += 2
      elsif operator == 4 # print output
        result = value(run_index, run_index + 1)
        @output << result
        @run_index += 2
        break if all
      elsif operator == 5 # jump if true
        result = value(run_index, run_index + 1)
        if result == 0
          @run_index += 3
          next
        end

        result = value(run_index, run_index + 2)
        @run_index = result
      elsif operator == 6 # jump if false
        result = value(run_index, run_index + 1)
        if result != 0
          @run_index += 3
          next
        end

        result = value(run_index, run_index + 2)
        @run_index = result
      elsif operator == 7 # less than
        result = value(run_index, run_index + 1) < value(run_index, run_index + 2)
        set_value(run_index, run_index + 3, (result ? 1 : 0))
        @run_index += 4
      elsif operator == 8 # equals
        result = value(run_index, run_index + 1) == value(run_index, run_index + 2)
        set_value(run_index, run_index + 3, (result ? 1 : 0))
        @run_index += 4
      elsif operator == 9 # relative base
        @relative_base += value(run_index, run_index + 1)
        @run_index += 2
      else
        puts "invalid operator #{operator}"
        break
      end
    end

    ouput_result = output.join.to_i
    return { output: ouput_result, parts: parts, index: run_index, halted: parts[run_index] == 99, relative_base: relative_base } if all
    return ouput_result if output.present?

    parts
  end
end

class Day09 < Helper
  def self.part1
    Machine.new(file).compute
  end

  def self.part2
    Machine.new(file).compute(input: 2)
  end
end

RSpec.describe "Day09" do
  it 'does day 9 - examples' do
    expect(Machine.new('1102,34915192,34915192,7,4,7,99,0').compute).to eq(1219070632396864)
    expect(Machine.new('104,1125899906842624,99').compute).to eq(1125899906842624)
    expect(Machine.new('109,2000,109,19,99').compute(all: true)[:relative_base]).to eq(2019)
  end

  it "does part 1" do
    expect(Day09.part1).to eq(3013554615) # 1091204 2030
  end

  it "does part 2" do
    expect(Day09.part2).to eq(50158)
  end
end
