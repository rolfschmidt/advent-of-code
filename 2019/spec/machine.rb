class Machine
  attr_accessor :parts, :run_index, :output, :relative_base, :all, :input, :input_index

  def initialize(parts, run_index: 0, relative_base: 0, all: false, input: 1, input_index: 0)
    @parts         = parts.is_a?(String) ? parts.split(/,/).map(&:to_i) : parts
    @output        = []
    @relative_base = relative_base
    @run_index     = run_index
    @all           = all
    @input         = Array.wrap(input)
    @input_index   = input_index
  end

  def halted?
    parts[run_index] == 99
  end

  def operator
    parts[run_index] % 100
  end

  def mode(value_index)
    data = parts[run_index].to_s.rjust(4, '0').chars.map(&:to_i)[...-2]

    return data[value_index * -1] || 0
  end

  def mode_index(value_index)
    mode = mode(value_index)

    result = nil
    if mode == 0 # position mode
      result = parts[run_index + value_index]
    elsif mode == 1 # immediate mode
      result = run_index + value_index
    elsif mode == 2 # relative mode
      result = relative_base + parts[run_index + value_index]
    else
      raise "invalid mode '#{mode}'!"
    end

    @parts << 0 while result > parts.size - 1

    result
  end

  def input_value
    value = @input[input_index]
    @input_index += 1
    value || 0
  end

  def value(value_index)
    to_index = mode_index(value_index)

    parts[to_index]
  end

  def value1
    value(1)
  end

  def value2
    value(2)
  end

  def value3
    value(3)
  end

  def value3=(value)
    set_value(3, value)
  end

  def set_value(value_index, value)
    to_index = mode_index(value_index)

    @parts[to_index] = value
  end

  def compute
    while true do
      case operator
      when 1 # add
        self.value3 = value1 + value2
        @run_index += 4
      when 2 # mul
        self.value3 = value1 * value2
        @run_index += 4
      when 3 # move
        to_index = mode_index(1)
        @parts[to_index] = input_value
        @run_index += 2
      when 4 # print output
        @output << value1
        @run_index += 2
        break if all
      when 5 # jump-if-true
        @run_index = value1 != 0 ? value2 : @run_index + 3
      when 6 # jump-if-false
        @run_index = value1 == 0 ? value2 : @run_index + 3
      when 7 # less than
        self.value3 = (value1 < value2).to_i
        @run_index += 4
      when 8 # equals
        self.value3 = (value1 == value2).to_i
        @run_index += 4
      when 9 # relative base
        @relative_base += value1
        @run_index += 2
      when 99
        break
      else
        raise "invalid operator #{operator}"
      end
    end

    ouput_result = output.join.to_i
    return { output: ouput_result, parts: parts, index: run_index, halted: halted?, relative_base: relative_base } if all
    return ouput_result if output.present?

    parts
  end
end
