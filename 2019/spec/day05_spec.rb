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

  def compute(input: nil)
    @run_index = 0
    while run_index != 99 do
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
        set_value(run_index, result, (!input.nil? ? input : 1))
        @run_index += 2
      elsif operator == 4 # print output
        result = value(run_index, run_index + 1)
        @output << result
        @run_index += 2
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

    return output.join.to_i if output.present?

    parts
  end
end

class Day05 < Helper
  def self.part1
    Machine.new(file.split(/,/).map(&:to_i)).compute
  end

  def self.part2
    Machine.new(file.split(/,/).map(&:to_i)).compute(input: 5)
  end
end

RSpec.describe "Day05" do
  def run(code, input: nil)
    value = Machine.new(code.split(/,/).map(&:to_i)).compute(input: input)
    value = value.join(',') if value.is_a?(Array)
    value
  end

  # it 'does run the machine' do
  #   expect(run('1,0,0,0,99')).to eq('2,0,0,0,99') # 1 + 1 = 2
  #   expect(run('2,3,0,3,99')).to eq('2,3,0,6,99') # 3 * 2 = 6
  #   expect(run('2,4,4,5,99,0')).to eq('2,4,4,5,99,9801') # 99 * 99 = 9801
  #   expect(run('1,1,1,4,99,5,6,0,99')).to eq('30,1,1,4,2,5,6,0,99') # day 2 example
  #   expect(run('1002,4,3,4,33')).to eq('1002,4,3,4,99') # 3 * 33 = 99
  # end

  it "does part 1" do
    expect(Day05.part1).to eq(4601506)
  end

  it "does part 2" do
    expect(Day05.part2).to eq(5525561)
  end
end
