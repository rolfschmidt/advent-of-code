class Day08 < Helper
  def self.part1
    file.split("\n").sum do |line|
      line.length - eval(line).length
    end
  end

  def self.part2
    file.split("\n").sum do |line|
      line.dump.length - line.length
    end
  end
end

RSpec.describe "Day08" do
  it "does part 1" do
    expect(Day08.part1).to eq(1333)
  end

  it "does part 2" do
    expect(Day08.part2).to eq(2046)
  end
end
