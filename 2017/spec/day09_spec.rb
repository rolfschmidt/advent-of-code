class Day09 < Helper
  def self.part1(part2 = false)
    level = 0
    groups = 0
    prog = file.split('')
    i = 0
    skip = false
    garbage = 0
    while i < prog.size
      c = prog[i]

      if c == "!"
        i += 1
      elsif c == ">"
        skip = false
      elsif skip
        garbage += 1
      elsif c == "{"
        level += 1
        groups += level * 1
      elsif c == "}"
        level -= 1
      elsif c == "<"
        skip = true
      end

      i += 1
    end
    return garbage if part2
    groups
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day09" do
  it "does part 1" do
    expect(Day09.part1).to eq(7616)
  end

  it "does part 2" do
    expect(Day09.part2).to eq(3838)
  end
end