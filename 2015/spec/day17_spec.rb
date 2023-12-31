class Day17 < Helper
  def self.part1(part2 = false)
    containers = file.split("\n").map(&:to_i).sort.reverse

    total = Set.new
    seen  = {}
    queue = [[Set.new, 150]]
    while queue.present?
      used, liters = queue.shift

      next if seen[used]
      seen[used] = true

      if liters == 0
        next if total.include?(used)
        total << used
        next
      end

      containers.each_with_index do |c, ci|
        next if used.include?(ci)
        next if liters < c

        queue << [used + [ci], liters - c]
      end
    end

    return total.select{|v| v.count == total.min_by(&:count).count }.count if part2

    total.count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day17" do
  it "does part 1" do
    expect(Day17.part1).to eq(1304)
  end

  it "does part 2" do
    expect(Day17.part2).to eq(18)
  end
end