class Day13 < Helper
  def self.compare(a, b)
    if a.is_a?(Integer) && b.is_a?(Integer)
      return 1 if a < b
      return -1 if a > b
      return 0
    elsif a.is_a?(Array) && b.is_a?(Array)
      while a.present? && b.present?
        res = compare(a.shift, b.shift)
        return res if res != 0
      end

      return 1 if a.blank? && b.present?
      return -1 if b.blank? && a.present?
      return 0
    elsif !a.is_a?(Array) || !b.is_a?(Array)
      return compare(Array(a), Array(b))
    end

    return 0
  end

  def self.part1(part2 = false)
    result = []
    all    = []
    file.split("\n\n").each_with_index do |line, i|
      a, b = line.split("\n").map{|v| JSON.parse(v) }
      all += [a, b]

      next if compare(a.deep_dup, b.deep_dup) != 1
      result << i + 1
    end

    if part2
      t1   = [[2]]
      t2   = [[6]]
      all += [t1, t2]
      all  = all.sort {|a,b| compare(a.deep_dup, b.deep_dup) }.reverse

      return (all.index(t1) + 1) * (all.index(t2) + 1)
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