class Day13 < Helper
  def self.reflection(map, part2 = false)
    map.keys.each_cons(2).find do |ai, bi|
      fails = 0
      while ai >= 0 && bi <= map.size - 1 && map[ai].present? && map[bi].present?
        if map[ai].present? && map[bi].present? && map[ai] != map[bi]
          fails += map[ai].keys.count{|i| map[ai][i] != map[bi][i] }
        end

        ai -= 1
        bi += 1
      end

      next if part2 && fails != 1
      next if !part2 && fails != 0

      true
    end&.second || 0
  end

  def self.part1(part2 = false)
    results = file.split("\n\n").map(&:to_2d).sum do |map_h|
      reflect_h = reflection(map_h, part2)
      map_v     = map_h.transpose
      reflect_v = reflection(map_v, part2)

      reflect_v + (reflect_h * 100)
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
