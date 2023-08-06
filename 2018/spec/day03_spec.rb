class Day03 < Helper
  def self.map
    @map ||= begin
      map = {}
      file.split("\n").each do |line|
        nums = line.scan(/\d+/).map(&:to_i)

        nums[3].times do |sx|
          nums[4].times do |sy|
            map[ [nums[1] + sx, nums[2] + sy] ] ||= { id: [nums[0]], count: 0 }
            map[ [nums[1] + sx, nums[2] + sy] ][:id] |= [nums[0]]
            map[ [nums[1] + sx, nums[2] + sy] ][:count] += 1
          end
        end
      end
      map
    end
  end

  def self.part1
    map.values.count{|v| v[:count] != 1}
  end

  def self.part2
    counts = {}
    map.values.each do |r|
      r[:id].each do |id|
        next if counts.key?(id)
        counts[id] ||= true
      end

      next if r[:count] == 1

      r[:id].each do |id|
        counts[id] = false
      end
    end

    counts.detect{|v| v[1] == true}[0]
  end
end

RSpec.describe "Day03" do
  it "does part 1" do
    expect(Day03.part1).to eq(118840)
  end

  it "does part 2" do
    expect(Day03.part2).to eq(919)
  end
end
