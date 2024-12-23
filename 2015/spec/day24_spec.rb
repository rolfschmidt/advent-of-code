class Day24 < Helper
  def self.part1(group_count = 3)
    rows = file.lines.map(&:to_i)

    @total       = rows.inject(&:+)
    @total_group = @total / group_count

    (1..rows.size).each do |group_size|
      rows.combination(group_size).each do |group1|
        next if group1.inject(&:+) % @total_group != 0

        rest = rows - group1
        (1..rest.size).each do |group_size|
          rows.combination(group_size).each do |group2|
            next if group2.inject(&:+) % @total_group != 0

            group3 = rest - group2
            next if group3.inject(&:+) % @total_group != 0

            result = [group1, group2, group3]
            return result.map { _1.inject(&:*) }.min
          end
        end
      end
    end
  end

  def self.part2
    part1(4)
  end
end

RSpec.describe "Day24" do
  it "does part 1" do
    expect(Day24.part1).to eq(11266889531) # 334919618123
  end

  it "does part 2" do
    expect(Day24.part2).to eq(77387711)
  end
end