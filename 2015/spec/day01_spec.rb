class Day01 < Helper
  def self.part1
    file.chomp.chars.sum {|c| c == '(' ? 1 : -1 }
  end

  def self.part2
    level = 0
    file.chomp.chars.each_with_index do |c, ci|
      level += c == '(' ? 1 : -1
      return ci + 1 if level < 0
    end
  end
end

RSpec.describe "Day01" do
  it "does part 1" do
    expect(Day01.part1).to eq(138)
  end

  it "does part 2" do
    expect(Day01.part2).to eq(1771)
  end
end
