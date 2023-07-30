class Day12 < Helper
  def self.groups(target, result = [])
    result |= [target]
    @pipes[target].each do |child|
      next if result.include?(child)

      result |= groups(child, result)
    end
    result
  end

  def self.part1(part2 = false)
    @pipes = {}
    file.split("\n").each do |line|
      row = line.split(" <-> ")
      row[1] = row[1].split(", ")

      @pipes[row[0]] ||= []
      row[1].each do |i|
        @pipes[i] ||= []
        @pipes[row[0]] |= [i]
        @pipes[i] |= [row[0]]
      end
    end

    if part2
      all = @pipes.keys

      total = 0
      while all.present?
        check = all.shift
        all -= groups(check)
        total += 1
      end

      return total
    end

    groups("0").count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(288)
  end

  it "does part 2" do
    expect(Day12.part2).to eq(211)
  end
end