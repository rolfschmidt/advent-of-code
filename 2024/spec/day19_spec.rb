class Day19 < Helper
  def self.matches(row)
    @patterns.select { row.starts_with?(_1) }
  end

  def self.search(row)
    cache(row) do
      row.blank?.to_i | matches(row).map { search(row[_1.size..]) }.sum
    end
  end

  def self.part1(part2 = false)
    patterns, designs = file.blocks

    @patterns = patterns.split(', ')
    matches   = designs.lines.map { search(_1) }

    if !part2
      matches.select(&:positive?).count
    else
      matches.sum
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day19" do
  it "does part 1" do
    expect(Day19.part1).to eq(367)
  end

  it "does part 2" do
    expect(Day19.part2).to eq(724388733465031) # 25958
  end
end