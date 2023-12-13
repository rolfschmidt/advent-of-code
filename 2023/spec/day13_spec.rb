class Day13 < Helper
  def self.reflection(map, part2 = false)
    map.keys.each_cons(2).find do |mai, mbi|
      fails = 0
      cai   = mai
      cbi   = mbi
      while cai >= 0 && cbi <= map.size - 1 && map[cai].present? && map[cbi].present?
        if map[cai].present? && map[cbi].present? && map[cai] != map[cbi]
          diff_size = map[cai].keys.count{|i| map[cai][i] != map[cbi][i] }
          fails += diff_size
        end

        cai -= 1
        cbi += 1
      end

      next if part2 && fails != 1
      next if !part2 && fails != 0

      [mai, mbi]
    end
  end

  def self.part1(part2 = false)
    results = file.split("\n\n").map(&:to_2d).sum do |map_h|
      reflect_h = reflection(map_h, part2)
      map_v     = map_h.transpose
      reflect_v = reflection(map_v, part2)

      (reflect_v ? reflect_v[1] : 0) + (reflect_h ? reflect_h[1] * 100 : 0)
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day13" do
  it "does part 1" do # 28572 43552 38418
    expect(Day13.part1).to eq(41859)
  end

  it "does part 2" do # 30592 36557 38933 50962 43507 25325 26686
    expect(Day13.part2).to eq(30842)
  end
end
