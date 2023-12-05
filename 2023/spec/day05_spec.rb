class Day05 < Helper
  def self.part1(part2 = false)
    blocks = file.split("\n\n")

    seeds = blocks.shift.scan(/\d+/).map(&:to_i).map{|n|  (n..n) }
    if part2
      seeds = seeds.each_slice(2).map{|c| (c[0].first..c[0].first + c[1].first - 1) }.flatten
    end

    areas = blocks.map do |block|
      block.scan(/\d+/).map(&:to_i).each_slice(3).map do |area|
        [ (area[1]..area[1] + area[2] - 1), (area[0]..area[0] + area[2] - 1) ]
      end
    end

    areas.each do |area|
      new_seeds = []
      while seeds.present?
        seed = seeds.shift

        found = area.any? do |location|
          match = seed & location[0]
          next if match.blank?

          seeds += seed - match
          new_seeds << (match.min - location[0].min + location[1].min .. match.max - location[0].min + location[1].min)
        end

        next if found

        new_seeds << seed
      end

      seeds = new_seeds
    end

    return seeds.map(&:min).min
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day05" do
  it "does part 1" do
    expect(Day05.part1).to eq(313045984)
  end

  it "does part 2" do
    expect(Day05.part2).to eq(20283860)
  end
end
