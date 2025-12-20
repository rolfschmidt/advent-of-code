class Day13 < Helper
  def self.part1
    machine = Machine.new(file)
    machine.compute

    map = {}
    count = 0
    machine.output.each_slice(3) do |x, y, t|
      map[Vector.new(x, y)] = t
    end

    map.select_value(2).keys.count
  end

  def self.part2
    machine          = Machine.new(file, input: 0)
    machine.parts[0] = 2
    score            = 0

    while !machine.halted? do
      machine.compute

      map = {}
      ball   = nil
      player = nil
      machine.output.each_slice(3) do |x, y, t|
        v = t
        case t
        when 0
          v = '.'
        when 1
          v = '#'
        when 2
          v = 'O'
        when 3
          v = '-'
          player = Vector.new(x, y)
        when 4
          v = '+'
          ball = Vector.new(x, y)
        end

        if x == -1 && y == 0
          score = t
        end

        # map[Vector.new(x, y)] = v
      end

      # puts map.to_2ds(fill_nil: true)

      if ball.x < player.x
        machine.set_input(-1)
      elsif ball.x > player.x
        machine.set_input(1)
      else
        machine.set_input(0)
      end

      # puts "score: #{score}"
      # sleep 0.001
    end

    score
  end
end

RSpec.describe "Day13" do
  it "does part 1" do
    expect(Day13.part1).to eq(236) # 220
  end

  it "does part 2" do
    expect(Day13.part2).to eq(11040)
  end
end
