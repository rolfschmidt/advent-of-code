class Day24 < Helper
  def self.search(list)

  end

  def self.part1
    rows = file.lines.map(&:to_i)

    @total = rows.inject(&:*)
    @total_group = @total / 3

    pp [@total, @total_group]

    exit
  end

  def self.part2
    100
  end
end

RSpec.describe "Day24" do
  it "does part 1" do
    expect(Day24.part1).to eq(100)
  end

  it "does part 2" do
    expect(Day24.part2).to eq(100)
  end
end