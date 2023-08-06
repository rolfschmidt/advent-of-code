class Day01 < Helper
  def self.part1
    file.split("\n").map(&:to_i).sum
  end

  def self.part2
    seen = []
    result = 0
    loop do
      file.split("\n").map(&:to_i).each do |num|
        result += num
        return result if seen.include?(result)

        seen << result
      end
    end
  end
end

RSpec.describe "Day01" do
  it "does part 1" do
    expect(Day01.part1).to eq(484)
  end

  it "does part 2" do
    expect(Day01.part2).to eq(367)
  end
end
