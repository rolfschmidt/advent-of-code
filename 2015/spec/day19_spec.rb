class Day19 < Helper
  def self.part1
    rules, value = file.blocks
    rules = rules.lines.map { _1.strip.split(' => ') }

    replacements = []
    rules.each do |rule|
      from, to = rule

      value.chars.each_with_index do |vc, vi|
        next if value[vi, from.length] != from

        value_new = value.clone
        value_new[vi, from.length] = to

        replacements |= [ value_new ]
      end
    end

    replacements.count
  end

  def self.part2
    rules, expect = file.blocks
    rules = rules.lines.map { _1.strip.split(' => ') }

    counter = 0
    while expect != 'e' do
      rules.each do |rule|
        from, to = rule
        next if expect.index(to).nil?

        counter += 1
        expect = expect.sub(to, from)
      end
    end

    counter
  end
end

RSpec.describe "Day19" do
  it "does part 1" do
    expect(Day19.part1).to eq(509)
  end

  it "does part 2" do
    expect(Day19.part2).to eq(195)
  end
end