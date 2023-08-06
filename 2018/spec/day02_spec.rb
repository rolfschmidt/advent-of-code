class Day02 < Helper
  def self.part1
    lines = file.split("\n").map do |line|
      count = line.chars.tally.values

      [(count.include?(2) ? 1 : 0), (count.include?(3) ? 1 : 0)]
    end

    lines.sum{|v| v[0] } * lines.sum{|v| v[1] }
  end

  def self.part2
    file.split("\n").each_with_index do |la, lai|
      file.split("\n").each_with_index do |lb, lbi|
        count = 0
        res = ''
        la.chars.each_with_index do |ca, cai|
          cb = lb.chars[cai]
          if ca != cb
            count += 1
          else
            res += ca
          end
        end

        return res if count == 1
      end
    end
  end
end

RSpec.describe "Day02" do
  it "does part 1" do
    expect(Day02.part1).to eq(3952)
  end

  it "does part 2" do
    expect(Day02.part2).to eq('vtnikorkulbfejvyznqgdxpaw') # vtnihorkucbfejxzmsqgdypaw vtrphonkulbfejcyzmsqgdxaw
  end
end
