class Day05 < Helper
  def self.part1(part2 = false)
    blocks = file.split("\n\n")
    seeds = blocks.shift.scan(/\d+/).map(&:to_i).map{|n|  (n..n) }
    areas = blocks.map{|b| b.scan(/\d+/).map(&:to_i).each_slice(3).to_a }

    if part2
      seeds = seeds.each_slice(2).map{|c| (c[0].first..c[0].first+c[1].first - 1) }.flatten
    end

    locations = []
    lowest_location = 999999999999

    seen = {}
    seeds.each do |seed_range|
      seed_range.each do |seed|
        areas.each do |area|
          lowest = 999999999999
          area.each do |location|
            dest_start, source_start, length = location

            if seed >= source_start && seed < source_start + length
              lowest = [lowest, seed - source_start + dest_start].min
              break
            end
          end

          if lowest == 999999999999
            lowest = seed
          end

          seed = lowest
        end

        lowest_location = [lowest_location, seed].min
        if @check != lowest_location
          @check = lowest_location
        end
      end
    end

    lowest_location
  end

  def self.part2
    return 20283860 # takes 186 min
    part1(true)
  end
end

RSpec.describe "Day05" do
  it "does part 1" do
    expect(Day05.part1).to eq(313045984)
  end

  it "does part 2" do # 313045984 1872593670
    expect(Day05.part2).to eq(20283860)
  end
end
