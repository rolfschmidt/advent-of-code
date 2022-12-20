class Day20 < Helper
  def self.part1(part2 = false)
    data = file.split("\n").map.with_index do |v, i|
      v = v.to_i
      if part2
        v *= 811589153
      end

      [v, i]
    end

    (part2 ? 10 : 1).times do
      data.size.times do |n|
        i = data.find_index {|v, i| i == n}
        v = data.delete_at(i)
        data.insert((i + v[0]) % data.size, v)
      end
    end

    zero = data.find_index {|v, i| v == 0 }

    [
      data[(zero + 1000) % data.size][0],
      data[(zero + 2000) % data.size][0],
      data[(zero + 3000) % data.size][0]
    ].sum
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day20" do
  it "does part 1" do
    expect(Day20.part1).to eq(11123)
  end

  it "does part 2" do
    expect(Day20.part2).to eq(4248669215955)
  end
end