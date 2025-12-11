class Day10 < Helper
  def self.machines
    @machines ||= begin
      machines = []
      file.lines.each do |line|
        spaces = line.split(' ')
        light, buttons = spaces[0], spaces[1..]
        light = light[1..-2].chars.map { _1 == '.' ? false : true }
        machines << [light, buttons[..-2].map(&:numbers), buttons[-1].numbers]
      end
      machines
    end
  end

  # rebuild part 1 in z3 by myself to learn z3 (kinda proud :D)
  def self.part1
    result = 0
    machines.each do |light, buttons|
      solver = Z3::Optimize.new
      presses = buttons.keys.map do |bi|
        z3b = Z3::Int("button_#{bi}")
        solver.assert(z3b >= 0)
        z3b
      end

      light.each_with_index do |value, li|
        light_buttons = buttons.keys.select { buttons[_1].include?(li) }

        solver.assert((light_buttons.map { presses[_1] }.sum % 2 == 1) == value)
      end

      solver.minimize(presses.sum)
      raise 'z3-error' if !solver.satisfiable?

      result += presses.map { solver.model[_1].to_i }.sum
    end
    result
  end

  # gave up, no math skills
  # yoinked, props to @firetech, https://github.com/firetech/advent-of-code/blob/0fb1c0178b4b6250487f0a6fbf0191e4331471e4/2025/10/factory_z3.rb
  def self.part2
    result = 0
    machines.each do |_, buttons, joltage|
      solver = Z3::Optimize.new
      presses = buttons.map do |bi|
        z3b = Z3::Int("button_#{bi}")
        solver.assert(z3b >= 0)
        z3b
      end

      joltage.each_with_index do |value, counter|
        jolly_buttons = buttons.keys.select { buttons[_1].include?(counter) }
        solver.assert(jolly_buttons.map { presses[_1] }.sum == value)
      end

      solver.minimize(presses.sum)
      raise 'z3-error' if !solver.satisfiable?

      result += presses.map { solver.model[_1].to_i }.sum
    end
    result
  end
end

RSpec.describe "Day10" do
  it "does part 1" do
    expect(Day10.part1).to eq(505)
  end

  it "does part 2" do
    expect(Day10.part2).to eq(20002) # 1320000003157
  end
end
