class Day20 < Helper
  def self.part1(part2 = false)
    list = []
    file.split("\n").each do |line|
      list << line.scan(/-?\d+/).map(&:to_i)
    end

    500.times do |r|
      seen = {}
      list.each_with_index do |v, vi|
        v[3] += v[6]
        v[4] += v[7]
        v[5] += v[8]
        
        v[0] += v[3]
        v[1] += v[4]
        v[2] += v[5]

        if part2 
          seen[v[0..2]] ||= []
          seen[v[0..2]] << vi
        end
      end

      destroy = seen.values.select{|v| v.count > 1 }.flatten
      list = list.select.with_index{|v, vi| destroy.exclude?(vi) }
    end

    return list.count if part2

    list.index(list.min_by{|v| v[0].abs + v[1].abs + v[2].abs })
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day20" do
  it "does part 1" do
    expect(Day20.part1).to eq(243) # 85 115 16 241
  end

  it "does part 2" do
    expect(Day20.part2).to eq(648) # 701
  end
end