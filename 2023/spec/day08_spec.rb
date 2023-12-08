class Day08 < Helper
  def self.dirs
    @dirs ||= begin
      dirs, input = file.split("\n\n")
      dirs = dirs.split("").map {|d| d == 'L' ? 1 : 2 }
    end
  end

  def self.input
    @input ||= begin
      dirs, input = file.split("\n\n")
      input = input.split("\n").map do |line|
        line.scan(/\w+/)
      end
    end
  end

  def self.search(start)
    search = start
    step   = 0
    while search !~ /.*Z$/ do
      @row ||= {}
      @row[search] ||= input.find{|v| v[0] == search }
      di      = dirs[step % dirs.count]
      search  = @row[search][di]
      step   += 1
    end
    step
  end

  def self.part1(part2 = false)
    return search('AAA') if !part2

    input.select{|v| v[0][-1] == 'A' }.map {|v| search(v[0]) }.inject(&:lcm)
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day08" do
  it "does part 1" do
    expect(Day08.part1).to eq(12737)
  end

  it "does part 2" do
    expect(Day08.part2).to eq(9064949303801)
  end
end
