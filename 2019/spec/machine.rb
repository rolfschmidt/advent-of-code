class Machine
  attr_accessor :parts, :run_index, :output, :relative_base

  def initialize(parts)
    @parts         = parts.is_a?(String) ? parts.split(/,/).map(&:to_i) : parts
    @output        = []
    @relative_base = 0
  end

  def operator
    @operator ||= {}
    @operator[run_index] ||= parts[run_index] % 100
  end

  def mode(value_index)
    data = parts[run_index] / 100
    ((data / (10 ** (value_index - run_index - 1))) % 10)
  end

  def mode_index(value_index)
    mode = mode(value_index)

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

  def value(value_index)
    to_index = mode_index(value_index)

    parts[to_index]
  end

  def set_value(value_index, value)
    to_index = mode_index(value_index)

    @parts[to_index] = value
  end

  def compute(input: 1, init_index: nil, all: false)
    @run_index  = init_index || 0
    input       = Array.wrap(input)
    input_index = init_index != 0 ? input.size - 1 : 0

    while true do
      case operator
      when 1 # add
        result = value(run_index + 1) + value(run_index + 2)
        set_value(run_index + 3, result)
        @run_index += 4
      when 2 # mul
        result = value(run_index + 1) * value(run_index + 2)
        set_value(run_index + 3, result)
        @run_index += 4
      when 3 # move
        to_index = mode_index(run_index + 1)
        @parts[to_index] = input[input_index] || input[0]
        input_index += 1
        @run_index += 2
      when 4 # print output
        result = value(run_index + 1)
        @output << result
        @run_index += 2
        break if all
      when 5 # jump if true
        result = value(run_index + 1)
        if result == 0
          @run_index += 3
          next
        end

        result = value(run_index + 2)
        @run_index = result
      when 6 # jump if false
        result = value(run_index + 1)
        if result != 0
          @run_index += 3
          next
        end

        result = value(run_index + 2)
        @run_index = result
      when 7 # less than
        result = value(run_index + 1) < value(run_index + 2)
        set_value(run_index + 3, (result ? 1 : 0))
        @run_index += 4
      when 8 # equals
        result = value(run_index + 1) == value(run_index + 2)
        set_value(run_index + 3, (result ? 1 : 0))
        @run_index += 4
      when 9 # relative base
        @relative_base += value(run_index + 1)
        @run_index += 2
      when 99
        break
      else
        raise "invalid operator #{operator}"
      end
    end

    ouput_result = output.join.to_i
    return { output: ouput_result, parts: parts, index: run_index, halted: parts[run_index] == 99, relative_base: relative_base } if all
    return ouput_result if output.present?

    parts
  end
end
