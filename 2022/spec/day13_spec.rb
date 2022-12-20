class Day13 < Helper
  def self.compare(a, b)
    if a.is_a?(Integer) && b.is_a?(Integer)
      return a <=> b
    elsif a.is_a?(Array) && b.is_a?(Array)
      aa = a.deep_dup
      bb = b.deep_dup
      while aa.present? && bb.present?
        res = compare(aa.shift, bb.shift)
        return res if res != 0
      end

      return -1 if aa.blank? && bb.present?
      return 1 if bb.blank? && aa.present?
      return 0
    end

    return compare(Array(a), Array(b))
  end

  def self.part1(part2 = false)
    result = []
    all    = []
    file.split("\n\n").each_with_index do |line, i|
      a, b = line.split("\n").map{|v| JSON.parse(v) }
      all += [a, b]

      next if compare(a, b) != -1
      result << i + 1
    end

    if part2
      d    = [[[2]], [[6]]]
      all  = (all + d).sort {|a,b| compare(a, b) }

      return (all.index(d[0]) + 1) * (all.index(d[1]) + 1)
    end

    return result.sum
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day13" do
  it "does part 1" do
    expect(Day13.part1).to eq(5625)
  end

  it "does part 2" do
    expect(Day13.part2).to eq(23111)
  end
end