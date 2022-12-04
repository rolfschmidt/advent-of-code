class Day04 < Helper
  def self.part1
    count = 0
    file.split("\n").each do |line|
      p1, p2 = line.split(",").map{|e| e.split("-").map(&:to_i) }

      if p1[0] <= p2[0] && p1[1] >= p2[1]
        count += 1
      elsif p2[0] <= p1[0] && p2[1] >= p1[1]
        count += 1
      end
    end

    count
  end

  def self.part2
    count = 0
    file.split("\n").each do |line|
      p1, p2 = line.split(",").map{|e| e.split("-").map(&:to_i) }.map{|a, b| (a..b).to_a }

      if (p1 & p2).count > 0
        count += 1
      end
    end

    count
  end
end

RSpec.describe "Day04" do
  it "does part 1" do
    expect(Day04.part1).to eq(448)
  end

  it "does part 2" do
    expect(Day04.part2).to eq(794)
  end
end