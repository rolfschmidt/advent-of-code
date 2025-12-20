class Day14 < Helper
  def self.graph
    @graph ||= begin
      graph = {}
      file.lines.each do |line|
        from, to = line.split(' => ')
        to_count, to = to.split(' ')

        graph[to] ||= { count: to_count.to_i, deps: [] }
        from.split(', ').each do |from|
          from_count, from = from.split(' ')
          graph[to][:deps] << [from_count.to_i, from]
        end
      end
      graph
    end
  end

  def self.cost(count, type)
    return 0 if count == 0
    return count if type == 'ORE'

    @stack       ||= {}
    @stack[type] ||= 0

    if @stack[type] >= count
      @stack[type] -= count
      return 0
    elsif @stack[type] < count
      count -= @stack[type]
      @stack[type] = 0
    end

    result     = 0
    multiplier = (count.to_f / graph[type][:count]).ceil.to_i
    total      = multiplier * graph[type][:count]
    graph[type][:deps].each do |dep|
      result += cost(multiplier * dep[0], dep[1])
    end

    if count < total
      @stack[type] += total - count
    end

    result
  end

  def self.part1
    cost(1, 'FUEL')
  end

  def self.part2
    (1..1000000000000).bsearch do |num|
      @stack = {}
      1000000000000 < cost(num.to_i, 'FUEL')
    end.to_i - 1
  end
end

RSpec.describe "Day14" do
  it "does part 1" do
    expect(Day14.part1).to eq(1590844)
  end

  it "does part 2" do
    expect(Day14.part2).to eq(1184209) # 1184210 1184211
  end
end
