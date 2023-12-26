class Day24 < Helper
  def self.stones
    @stones ||= file.split("\n").map{|line| line.numbers }
  end

  def self.elim(m)
    0.upto(m.size-1) do |i|
        t=m[i][i]; m[i].map!{|x| x/t}
        (i+1...m.size).each do |j|
            t=m[j][i]; m[j].map!.with_index{|x,k| x-t*m[i][k]}
        end
    end
    (m.size-1).downto(0) do |i|
        (0...i).each do |j|
            t=m[j][i]; m[j].map!.with_index{|x,k| x-t*m[i][k]}
        end
    end
    m
  end

  def self.mat(stones, x, y, dx, dy)
    m = stones.map{|s| [-s[dy], s[dx], s[y], -s[x], s[y]*s[dx]-s[x]*s[dy]] }
    m.take(4).map{|r| r.zip(m[-1]).map{|a,b|(a-b).to_r} }
  end

  # no math skills, gave up
  # props to https://github.com/tckmn/polyaoc-2023/blob/97689dc6b5ff38c557cd885b10be425e14928958/24/rb/24.rb
  def self.part1
    tmin = 200000000000000
    tmax = 400000000000000

    return stones.combination(2).count do |a, b|
      ax, ay, _, adx, ady, _ = a.map(&:to_f)
      bx, by, _, bdx, bdy, _ = b.map(&:to_f)

      bt = ((bx-ax) / adx - (by-ay) / ady) / (bdy/ady - bdx/adx)
      at = (bx + bt*bdx - ax) / adx

      ix = ax+adx*at
      iy = ay+ady*at

      bt >= 0 && at >= 0 && tmin <= ix && ix <= tmax && tmin <= iy && iy <= tmax
    end
  end

  # no math skills, gave up
  # props to https://github.com/tckmn/polyaoc-2023/blob/97689dc6b5ff38c557cd885b10be425e14928958/24/rb/24.rb
  def self.part2
    x, y, *_ = elim(mat stones, 0, 1, 3, 4).map(&:last)
    z,    *_ = elim(mat stones, 2, 1, 5, 4).map(&:last)
    return (x+y+z).to_i
  end
end

RSpec.describe "Day24" do
  it "does part 1" do # 11305 10842
    expect(Day24.part1).to eq(12015)
  end

  it "does part 2" do
    expect(Day24.part2).to eq(1016365642179116)
  end
end