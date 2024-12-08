class Day08 < Helper
  def self.part1(part2 = false)
    map     = file.to_map
    atennas = map.select { map[_1] != '.' }.reverse

    result = map.clone
    atennas.each do |atenna, list|
      list.combination(2).each do |pa, pb|
        diff = pa - pb

        [Vector.new(1, 1), Vector.new(-1, -1)].each do |dr|
          ta = pa + (diff * dr)
          tb = pb + (diff * dr)

          while map[ta].present? && map[tb].present? do
            result[ta] = '#' if map[ta].present? && map[ta] != atenna
            result[tb] = '#' if map[tb].present? && map[tb] != atenna
            break if !part2

            ta += diff * dr
            tb += diff * dr
          end
        end
      end
    end

    if part2
      result.values.count{ _1 != '.' }
    else
      result.values.count('#')
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day08" do
  it "does part 1" do
    expect(Day08.part1).to eq(301) # 302
  end

  it "does part 2" do
    expect(Day08.part2).to eq(1019) # 474 649
  end
end