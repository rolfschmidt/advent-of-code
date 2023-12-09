class Day09 < Helper
  def self.part1(part2 = false)
    lines = file.split("\n").map(&:numbers)

    total = []
    lines.each do |sequence|
      diff = [sequence]

      while diff.last.uniq != [0] && diff.last.present?
        new_seq = []
        diff.last.each_with_index do |n, i|
          next if i > diff.last.size - 2

          i2 = i + 1
          n2 = diff.last[i2]

          new_seq << n2 - n
        end

        diff << new_seq
      end

      if part2
        diff = diff.map(&:reverse)
      end

      diff[-1] << 0
      (1..diff.count - 1).to_a.reverse.each do |ci|
        if part2
          diff[ci - 1] << (diff[ci - 1].last - diff[ci].last)
        else
          diff[ci - 1] << (diff[ci].last + diff[ci - 1].last)
        end
      end

      total << diff[0].last
    end

    total.sum
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
