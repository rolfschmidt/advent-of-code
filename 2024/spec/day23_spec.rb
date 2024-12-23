class Day23 < Helper
  def self.part1(part2 = false)
    range       = part2 ? (3..1000) : (3..3)
    connections = {}
    file.lines.map { _1.split('-') }.each do |a, b|
      connections[a] ||= Set.new
      connections[a] << b
      connections[b] ||= Set.new
      connections[b] << a
    end

    sets = Set.new
    connections.each do |from, to|
      next if from[0] != 't'

      range.each do |counter|
        combos = [from, *to].combination(counter)
        break if combos.blank?

        combos.each do |list|
          next if list.none? { _1[0] == 't' }
          next if list.combination(2).any? { connections[_1].exclude?(_2) }

          sets << list.to_set
        end
      end
    end

    return sets.max_by(&:size).sort.join(',') if part2

    sets.count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day23" do
  it "does part 1" do
    expect(Day23.part1).to eq(1302) # 4732 2024 1630 6411
  end

  it "does part 2" do
    expect(Day23.part2).to eq('cb,df,fo,ho,kk,nw,ox,pq,rt,sf,tq,wi,xz')
  end
end