class Day07 < Helper
  def self.part1(part2 = false)
    ops = {
      'AND'    => '&',
      'OR'     => '|',
      'NOT'    => '~',
      'RSHIFT' => '>>',
      'LSHIFT' => '<<'
    }

    stack = {}
    program = file.split("\n").map do |line|
      line.gsub!(/([a-z]+)/, 'stack[\'\1\']')

      operation, target = line.split(' -> ')
      ops.each do |op_from, op_to|
        operation.gsub!(op_from, op_to)
      end

      if part2 && target == "stack['b']"
        operation = part1(false)
      end

      "#{target} = #{operation}"
    end

    loop do
      errors = false
      program.each { |code| eval(code) rescue errors = true }
      redo if errors
      break
    end

    stack['a']
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day07" do
  it "does part 1" do
    expect(Day07.part1).to eq(956)
  end

  it "does part 2" do
    expect(Day07.part2).to eq(40149)
  end
end
