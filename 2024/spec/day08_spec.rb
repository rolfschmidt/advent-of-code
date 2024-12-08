class Day08 < Helper
  def self.part1(part2 = false)
    map = file.to_map

    atenna = {}
    map.select { map[_1] != '.' }.map do
      atenna[_2] ||= []
      atenna[_2] |= [_1]
    end

    result = map.clone
    atenna.each do |key, list|
      list.combination(2).each do |pa, pb|
        diff    = pa - pb
        diff.x  = diff.x
        diff.y  = diff.y

        [1, -1].each do |da|
          pax = pa.x + (diff.x * da)
          pay = pa.y + (diff.y * da)
          pbx = pb.x + (diff.x * da)
          pby = pb.y + (diff.y * da)

          while map[Vector.new(pax, pay)].present? && map[Vector.new(pbx, pby)].present? do
            result[Vector.new(pax, pay)] = '#' if map[Vector.new(pax, pay)].present? && map[Vector.new(pax, pay)] != key
            result[Vector.new(pbx, pby)] = '#' if map[Vector.new(pbx, pby)].present? && map[Vector.new(pbx, pby)] != key

            pax += (diff.x * da)
            pay += (diff.y * da)
            pbx += (diff.x * da)
            pby += (diff.y * da)
            break if !part2
          end
        end
      end
    end

    if part2
      result.values.count{ _1 != '.' }
    else
      result.to_2ds.count('#')
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