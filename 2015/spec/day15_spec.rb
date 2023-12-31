class Day15 < Helper
  def self.part1(part2 = false)
    list   = file.split("\n").map(&:numbers)
    totals = {}
    list.each_with_index do |v, vi|
      (0..100).each do |r|
        totals[vi] ||= {}
        totals[vi][r] = v.map{|i| i * r }
      end
    end

    best = 0
    (0..100).each do |a|
      (0..100 - a).each do |b|
        (0..100 - a - b).each do |c|
          (0..100 - a - b - c).each do |d|
            next if a + b + c + d != 100

            ta = totals[0][a][0] + totals[1][b][0] + totals[2][c][0] + totals[3][d][0]
            tb = totals[0][a][1] + totals[1][b][1] + totals[2][c][1] + totals[3][d][1]
            tc = totals[0][a][2] + totals[1][b][2] + totals[2][c][2] + totals[3][d][2]
            td = totals[0][a][3] + totals[1][b][3] + totals[2][c][3] + totals[3][d][3]
            te = totals[0][a][4] + totals[1][b][4] + totals[2][c][4] + totals[3][d][4]
            next if part2 && te != 500

            best = [best, [ta, tb, tc, td].select(&:positive?).inject(:*)].max
          end
        end
      end
    end
    best
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day15" do
  it "does part 1" do
    expect(Day15.part1).to eq(21367368)
  end

  it "does part 2" do
    expect(Day15.part2).to eq(1766400)
  end
end