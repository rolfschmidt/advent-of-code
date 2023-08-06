class Day05 < Helper
  def self.part1(list = nil)
    if !list
      list = file.strip.chars
    end

    ci = 0
    while ci < list.size do
      c = list[ci]
      if c.downcase == list[ci + 1]&.downcase
        if (c.is_lower? && list[ci + 1]&.is_upper?) || (c.is_upper? && list[ci + 1]&.is_lower?)
          list.delete_at(ci + 1)
          list.delete_at(ci)
          ci -= 2
          next
        end
      end
      ci += 1
    end

    list.count
  end

  def self.part2
    list = file.strip.chars
    chars = list.join.downcase.chars.uniq

    min = 999999999999
    chars.each do |c|
      clist = (list - [c.upcase, c.downcase])
      min = [min, part1(clist)].min
    end

    min
  end
end

RSpec.describe "Day05" do
  it "does part 1" do
    expect(Day05.part1).to eq(11108)
  end

  it "does part 2" do
    expect(Day05.part2).to eq(5094)
  end
end
