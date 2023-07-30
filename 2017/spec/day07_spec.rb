class Day07 < Helper
  @nums = {}
  @tree = {}

  def self.part1
    file.tr(',', '').split("\n").map{|s| s.split(" ").select{|v| v.match?(/[a-zA-Z]/) } }.flatten.tally.detect{|v| v[1] == 1 }.first
  end

  def self.count_tree(name, deep: false)
    childs       = Array(@tree[name]).map{|v| [v, count_tree(v).first ] }
    child_counts = childs.map{|v| v[1] }
    good_weight  = child_counts.tally.detect{|v| v[1] != 1 }&.first || 0
    wrong_weight = child_counts.tally.detect{|v| v[1] == 1 }&.first || 0
    wrong_child  = childs.detect{|v| v[1] == wrong_weight }

    if child_counts.present? && child_counts.uniq.count != 1 && deep
      return count_tree(wrong_child[0], deep: deep)
    end

    [@nums[name].to_i + child_counts.sum, name, @nums[name], wrong_child, good_weight - wrong_weight]
  end

  def self.part2
    file.tr(',()', '').split("\n").each do |line|
      t = line.split(" ").first

      @nums[t] = line.scan(/\d+/).first.to_i
      @tree[t] ||= line.split(" -> ").second&.split(" ")
    end

    count = count_tree(part1)
    count2 = count_tree(part1, deep: true)

    count2[2] + count[4]
  end
end

RSpec.describe "Day07" do
  it "does part 1" do
    expect(Day07.part1).to eq('ykpsek')
  end

  it "does part 2" do
    expect(Day07.part2).to eq(1060)
  end
end