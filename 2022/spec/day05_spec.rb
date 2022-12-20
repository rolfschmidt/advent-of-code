class Day05 < Helper
  def self.part1(part2 = false)
    stack = []
    file.split("\n\n")[0].split("\n").each do |line|
      line.chars.each_with_index do |c, i|
        next if i % 4 == 0
        next if all_chars.exclude?(c)

        stack[i / 4 + 1] ||= []
        stack[i / 4 + 1].unshift(c)
      end
    end

    file.split("\n\n")[1].split("\n").each do |line|
      count, from, to = line.scan(/\d+/).map(&:to_i)

      if !part2
        stack[to] += stack[from].pop(count).reverse
      else
        stack[to] += stack[from].pop(count)
      end
    end

    stack.compact.map(&:last).join
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