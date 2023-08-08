class Day11 < Helper
  def self.part1(part2 = false)
    sn = file.to_i

    map = []
    (0..299).each do |y|
      (0..299).each do |x|
        rack_id = x + 1 + 10
        power_level = rack_id * (y + 1)
        power_level += sn
        power_level *= rack_id
        power_level = power_level.to_s[-3].to_i - 5
        map[y] ||= []
        map[y] << power_level
      end
    end

    range = (2..2)
    if part2
      range = (0..300)
    end

    max_pos = nil
    max_sum = 0
    max_size = 0
    counter = 0
    map.each_with_index do |yv, yi|
      yv.each_with_index do |xv, xi|
        counter += 1
        if counter % 5000 == 0
          puts "#{counter} / #{map.size * map.first.size}" if part2
        end

        range.each do |r|
          break if yi + r > 299
          break if xi + r > 299

          pos_sum = 0
          (yi..yi + r).each do |ry|
            pos_sum += map[ry][xi..xi + r].sum
          end

          if pos_sum > max_sum
            max_pos = Vector.new(xi + 1, yi + 1)
            max_sum = pos_sum
            max_size = r
          end
        end
      end
    end

    return "#{max_pos.x},#{max_pos.y},#{max_size + 1}" if part2

    "#{max_pos.x},#{max_pos.y}"
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day11" do
  it "does part 1" do
    expect(Day11.part1).to eq('20,58')
  end

  it "does part 2" do
    expect(Day11.part2).to eq('233,268,13')
  end
end
