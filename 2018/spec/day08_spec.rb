class Day08 < Helper
  def self.parse(nums)
      cc = nums.shift
      mc = nums.shift

      childs = []
      cc.times do
        childs << parse(nums)
      end

      meta = []
      mc.times do
        meta << nums.shift
      end

      return {
        childs: childs,
        meta: meta,
      }
  end

  def self.count_meta(tree)
    result = tree[:meta].sum
    tree[:childs].each do |c|
      result += count_meta(c)
    end
    result
  end

  def self.part1
    nums = file.split(' ').map(&:to_i)
    tree = parse(nums)
    count_meta(tree)
  end

  def self.count_index(tree)
    result = 0
    return tree[:meta].sum if tree[:childs].blank?

    tree[:meta].each do |i|
      child = tree[:childs][i - 1]
      next if child.blank?

      result += count_index(child)
    end

    result
  end

  def self.part2
    nums = file.split(' ').map(&:to_i)
    tree = parse(nums)
    count_index(tree)
  end
end

RSpec.describe "Day08" do
  it "does part 1" do
    expect(Day08.part1).to eq(46781)
  end

  it "does part 2" do
    expect(Day08.part2).to eq(21405)
  end
end
