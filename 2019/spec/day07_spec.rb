class Machine
  attr_accessor :parts, :run_index, :output

  def initialize(parts)
    @parts  = parts
    @output = []
  end

  def op(op_index)
    return parts[op_index] if parts[op_index] <= 10

    data = parts[op_index].to_s.chars

    return "#{data[-2]}#{data[-1]}".to_i
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

  def value(op_index, value_index)
    mode = mode(op_index, value_index)

    (mode == 0 ? parts[parts[value_index]] : parts[value_index])
  end

  def set_value(op_index, value_index, value)
    mode = mode(op_index, value_index)

    if mode == 0
      @parts[parts[value_index]] = value
    else
      @parts[value_index] = value
    end

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
        result = value(run_index, run_index + 1)

        set_input = !input[input_index].nil? ? input[input_index] : input[0]
        set_value(run_index, result, set_input)

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
      else
        puts "invalid operator #{operator}"
        break
      end
    end

    ouput_result = output.join.to_i
    return { output: ouput_result, parts: parts, index: run_index, halted: parts[run_index] == 99 } if all
    return ouput_result if output.present?

    parts
  end
end

class Day07 < Helper
  def self.amp_sequence_list_get(from, to)
    (from..to).to_a.permutation(5).to_a
  end

  def self.amp_run(code, sequences)
    outputs = []

    sequences.each do |sequence|
      amp_outputs = 0
      index_memory = {}
      index_code = {}
      amp_index = 0
      while amp_index < 5 do
        index_memory[amp_index] ||= 0
        index_code[amp_index] ||= code.clone

        sequence_value = sequence[amp_index]
        ra = Machine.new(index_code[amp_index].clone).compute(input: [sequence_value, amp_outputs], all: true, init_index: index_memory[amp_index])

        amp_outputs = ra[:output] if !ra[:output].nil?

        outputs << amp_outputs

        raise 'next_seq' if ra[:halted] && amp_index == 4 && part2?

        if part2?
          index_memory[amp_index] = ra[:index]
          index_code[amp_index] = ra[:parts]

          if amp_index == 4
            amp_index = 0
            next
          end
        end

        amp_index += 1
      end

    rescue => e
      next if e.message == 'next_seq'
      raise e
    end

    outputs
  end

  def self.part1
    code = file.split(/,/).map(&:to_i)
    amp_run(code, amp_sequence_list_get(0, 4)).max
  end

  def self.part2
    code = file.split(/,/).map(&:to_i)
    amp_run(code, amp_sequence_list_get(5, 9)).max
  end
end

RSpec.describe "Day07" do
  it "does part 1" do
    expect(Day07.part1).to eq(262086)
  end

  it "does part 2" do
    expect(Day07.part2).to eq(5371621)
  end
end
