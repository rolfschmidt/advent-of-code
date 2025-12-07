Cart = Struct.new(:pos, :dir, :active, :plus)

class Day13 < Helper
  def self.part1
    map = file.to_map

    carts = map.select_value(['^', 'v', '<', '>'])
    carts = carts.map do |key, value|
      if ['<', '>'].include?(map[key])
        map[key] = '-'
      elsif ['^', 'v'].include?(map[key])
        map[key] = '|'
      end

      Cart.new(
        pos: key,
        dir: DIRS_STRING[value].clone,
        active: true,
        plus: [:rotate_right, :rotate_left, :clone],
      )
    end

    loop do
      carts.sort_by!{|c| c.pos.to_a.reverse }

      carts.each do |cart|
        next if !cart.active

        next_pos = cart.pos + cart.dir

        crash = carts.find { _1.pos == next_pos && _1.active }
        if crash
          return "#{next_pos.x},#{next_pos.y}" if !part2?

          cart.active = false
          crash.active = false

          actives = carts.select { _1.active }
          return "#{actives[0].pos.x},#{actives[0].pos.y}" if actives.count == 1

          next
        end

        cart.pos = next_pos

        if map[cart.pos] == '+'
          cart.plus = cart.plus.rotate(1)
          cart.dir = cart.dir.send(cart.plus.first)
        elsif map[cart.pos] == '/'
          cart.dir = cart.dir.diagonal_neg
        elsif map[cart.pos] == '\\'
          cart.dir = cart.dir.diagonal_pos
        end
      end
    end
  end

  def self.part2
    part1
  end
end

RSpec.describe "Day13" do
  it "does part 1" do
    expect(Day13.part1).to eq('33,69')
  end

  it "does part 2" do
    expect(Day13.part2).to eq('135,9') # 123,125 124,125 144,95 144,96 90,141
  end
end
