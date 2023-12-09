class Day09 < Helper
  def self.part1(part2 = false)
    lines = file.split("\n").map(&:numbers)

    lines.map do |sequence|
      diff = [sequence]
      while diff.last.uniq != [0] && diff.last.present?
        diff << diff.last.each_cons(2).map{|a, b| b - a}
      end

      if part2
        diff = diff.map(&:reverse)
      end

      diff.keys.reverse.each_cons(2) do |bi, ai|
        diff[ai] << if part2
                          diff[ai].last - diff[bi].last
                        else
                          diff[bi].last + diff[ai].last
                        end
      end

      diff[0].last
    end.sum
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day09" do
  it "does part 1" do # 2416390430 2193170144 2024526990
    expect(Day09.part1).to eq(2175229206)
  end

  it "does part 2" do
    expect(Day09.part2).to eq(942)
  end
end
