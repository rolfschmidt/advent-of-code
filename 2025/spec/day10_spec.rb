class Day10 < Helper
  def self.lights
    @lights ||= begin
      lights = []
      file_test.lines.each do |line|
        spaces = line.split(' ')
        light, buttons = spaces[0], spaces[1..]
        light = light[1..-2].chars.map { _1 == '.' ? false : true }
        lights << [light, buttons[..-2].map(&:numbers), buttons[-1].numbers]
      end
      lights
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

    lights[li][1].shuffle.each do |pc|
      next if pressed >= @best
      press(pressed.clone, light.clone, pc.clone, li)
    end
  end

  def self.part1
    Parallel.map(lights.keys) do |li|
      light = lights[li]
    # lights.map.with_index do |light, li|
      @best = 10000000000
      @cache = {}
      light[1].each do |pc|
        reset_cache
        press(0, light[0].clone, pc.clone, li)
      end
      @best
    end.sum
  end

  def self.jolly_state(button, jolly)
    result = jolly.clone
    pressed = 0
    while_stable do
      can_more = true
      button.each do |value|
        result[value] -= 1
        can_more = false if result[value] < 1
        raise if result[value] < 0
      end

      pressed += 1

      # stable if can_more
    end
    [pressed, result]
  rescue
    nil
  end

  def self.jollize(pressed, buttons, jolly)
    return if pressed >= @best

    return if @cache[jolly] && @cache[jolly] <= pressed
    @cache[jolly] = pressed

    if jolly.all?(0) && pressed < @best
      pp ['best', pressed]
      @best = pressed
      return
    end

    buttons.each do |button|
      new_pressed, new_jolly = jolly_state(button, jolly)
      next if new_jolly.blank?

      new_pressed += pressed
      next if new_pressed >= @best

      jollize(new_pressed, buttons, new_jolly)
    end
  end


  def self.part2
    lights.keys.map do |li|
      data    = lights[li]
      light   = data[0]
      buttons = data[1]
      jolly   = data[2]

      @best = 10000000000
      @cache = {}

      @cache = {}
      jollize(0, buttons, jolly)

      @best
    end.sum
  end
end

RSpec.describe "Day10" do
  it "does part 1" do
    # expect(Day10.part1).to eq(505)
  end

  it "does part 2" do
    expect(Day10.part2).to eq(100) # 1320000003157
  end
end
