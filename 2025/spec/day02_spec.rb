class Day02 < Helper
  def self.part1
    file.split(',').map(&:strip).sum do |value|
      value.dash_pair.to_range.select do |num|
        num.to_s.halve.same?
      end.sum
    end
  end

  def self.part2
    Parallel.map(file.split(',').map(&:strip)) do |value|
      value.dash_pair.to_range.map(&:to_s).select do |chain|
        chain.sequences(count: 1).present?
      end.map(&:to_i).sum
    end.sum
  end
end

RSpec.describe "Day02" do
  it "does part 1" do
    expect(Day02.part1).to eq(28846518423)
  end

  it "does part 2" do
    expect(Day02.part2).to eq(31578210022)
  end
end
