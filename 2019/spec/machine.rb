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
    data = parts[op_index] / 100
    ((data / (10 ** (value_index - op_index - 1))) % 10)
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
        to_index = mode_index(mode(run_index, run_index + 1), run_index + 1)
        @parts[to_index] = input[input_index] || input[0]
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
