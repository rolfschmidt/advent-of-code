class Day05 < Helper
  def self.part1(part2 = false)
    stack = {}
    file.split("\n\n")[0].split("\n").each do |line|
      chs = line.chars.unshift("").unshift("").unshift("")

      line.chars.each_with_index do |c, i|
        next if i % 4 == 0
        next if all_chars.exclude?(c)

        ti = 1
        if i > 1
          ti = i / 4 + 1
        end

        stack[ti] ||= []
        stack[ti].unshift(c)
      end
    end

    file.split("\n\n")[1].split("\n").each do |line|
      count, from, to = line.scan(/\d+/).map(&:to_i)

      if !part2
        count.times do
          stack[to] << stack[from].pop
        end
      else
        pick = []
        count.times do
          pick.unshift(stack[from].pop)
        end

        stack[to] += pick
      end
    end

    stack.keys.sort.map {|i| stack[i].last }.join
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day05" do
  it "does part 1" do
    expect(Day05.part1).to eq("VPCDMSLWJ")
  end

  it "does part 2" do
    expect(Day05.part2).to eq("TPWCGNCCG")
  end
end