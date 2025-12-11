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

  def self.light_state(light, buttons)
    cache(light, buttons) do
      light = light.clone
      buttons.each do |bi|
        light[bi] = !light[bi]
      end
      light
    end
  end

  def self.press(pressed, light, buttons, li)
    return if pressed >= @best

    light = light_state(light, buttons)
    pressed += 1

    return if @cache[light] && @cache[light] <= pressed
    @cache[light] = pressed

    if light.all?(false) && pressed < @best
      @best = pressed
      return @best if @best <= 1
    end

    machines[li][1].shuffle.each do |pc|
      next if pressed >= @best
      press(pressed.clone, light.clone, pc.clone, li)
    end
  end

  def self.part1
    Parallel.map(machines.keys) do |li|
      light = machines[li]
    # machines.map.with_index do |light, li|
      @best = 10000000000
      @cache = {}
      light[1].each do |pc|
        reset_cache
        press(0, light[0].clone, pc.clone, li)
      end
      @best
    end.sum
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
